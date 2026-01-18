# SMELL DETECTION REPORT: simple_mock

## Smell Summary

| Smell Type | Count | High | Medium | Low |
|------------|-------|------|--------|-----|
| God Class | 0 | 0 | 0 | 0 |
| Feature Envy | 1 | 0 | 1 | 0 |
| Long Param List | 0 | 0 | 0 | 0 |
| Data Clumps | 1 | 0 | 0 | 1 |
| Primitive Obsession | 2 | 0 | 1 | 1 |
| Dead Code | 0 | 0 | 0 | 0 |
| Inappropriate Intimacy | 0 | 0 | 0 | 0 |
| Speculative Generality | 0 | 0 | 0 | 0 |
| Comment Smells | 1 | 0 | 0 | 1 |

**Total: 5 smells (0 High, 2 Medium, 3 Low)**

---

## GOD CLASS SCAN

Detection criteria: > 20 features, > 300 lines, multiple responsibilities

| Class | Features | Lines | Status |
|-------|----------|-------|--------|
| SIMPLE_MOCK | 20 | 191 | BORDERLINE - 4 responsibilities but manageable |
| MOCK_VERIFIER | 18 | 220 | OK - All verification-related |
| MOCK_REQUEST | 16 | 139 | OK - Single responsibility |
| MOCK_RESPONSE | 14 | 115 | OK |
| MOCK_SERVER | 14 | 161 | OK |
| MOCK_EXPECTATION | 14 | 153 | OK |
| MOCK_MATCHER | 12 | 186 | OK |

**RESULT: No God Classes detected**

SIMPLE_MOCK has 4 distinct feature groups but this is intentional Facade pattern - providing unified API over multiple internal classes.

---

## FEATURE ENVY SCAN

Detection criteria: Feature accesses > 3 features of another class

### FEATURE ENVY: MOCK_VERIFIER.request_count

```eiffel
request_count (a_url: STRING): INTEGER
    do
        across server.received_requests as l_req loop
            if l_req.url.same_string (a_url) or l_req.url.has_substring (a_url) then
                Result := Result + 1
            end
        end
    end
```

**Analysis:**
- Uses from MOCK_SERVER: `received_requests` (1 feature)
- Uses from MOCK_REQUEST: `url.same_string`, `url.has_substring` (2 method calls)
- Uses from own class: 0
- External > Internal: YES

**SEVERITY: MEDIUM**

The matching logic (`same_string` or `has_substring`) is duplicated across multiple features in MOCK_VERIFIER. Should delegate to MOCK_REQUEST or MOCK_MATCHER.

**RECOMMENDATION:** Add `matches_url (a_pattern: STRING): BOOLEAN` to MOCK_REQUEST.

---

## LONG PARAMETER LIST SCAN

Detection criteria: > 4 parameters

| Feature | Params | Status |
|---------|--------|--------|
| MOCK_EXPECTATION.make | 2 | OK |
| MOCK_MATCHER.make | 2 | OK |
| MOCK_REQUEST.make | 2 | OK |
| MOCK_SERVER.make | 1 | OK |
| MOCK_RESPONSE.make_with_body | 2 | OK |

**RESULT: No Long Parameter Lists detected**

Maximum parameters: 2 (all creation procedures)

---

## DATA CLUMPS SCAN

Detection criteria: Same 3+ fields in multiple classes

### DATA CLUMP: HTTP Headers Pattern

**Fields:** `headers: HASH_TABLE [STRING, STRING]`, `add_header`, `has_header`

**Appears in:**
- MOCK_REQUEST (lines 57, 120, 74)
- MOCK_RESPONSE (lines 37, 97)

**SEVERITY: LOW**

Both classes have nearly identical header handling code:
```eiffel
-- MOCK_REQUEST:
headers: HASH_TABLE [STRING, STRING]
add_header (a_name, a_value: STRING) do headers.force (a_value, a_name) end
has_header (a_name: STRING): BOOLEAN do Result := headers.has (a_name) end

-- MOCK_RESPONSE:
headers: HASH_TABLE [STRING, STRING]
add_header (a_name, a_value: STRING) do headers.force (a_value, a_name) end
```

**RECOMMENDATION:** Could extract HTTP_HEADERS class, but overhead may not be worth it for this small library.

---

## PRIMITIVE OBSESSION SCAN

Detection criteria: STRING used for structured data

### PRIMITIVE OBSESSION 1: HTTP Methods as STRING

**Location:** All classes use `method: STRING` for HTTP methods

**Files:**
- MOCK_REQUEST.method: STRING
- MOCK_EXPECTATION (via MOCK_MATCHER)
- MOCK_MATCHER.method: STRING

**Semantic:** HTTP method (GET, POST, PUT, DELETE, PATCH, etc.)
**Should be:** HTTP_METHOD or enum
**Validation needed:** Must be valid HTTP method

**SEVERITY: MEDIUM**

No validation that method is a valid HTTP method. Could pass "BANANA" as method.

**RECOMMENDATION:** Create HTTP_METHOD class with factory methods `get`, `post`, `put`, `delete` and validation.

### PRIMITIVE OBSESSION 2: Port as INTEGER

**Location:** MOCK_SERVER, SIMPLE_MOCK

**Semantic:** TCP port number
**Should be:** PORT_NUMBER or keep as INTEGER with validation
**Validation needed:** 1-65535

**SEVERITY: LOW**

Contracts already validate `port > 0 and port <= 65535`. Primitive is acceptable here.

---

## DEAD CODE SCAN

Detection criteria: Features never called

**Analysis of MOCK_VERIFIER features:**

| Feature | Called by | Status |
|---------|-----------|--------|
| was_requested_times | None found | POTENTIALLY DEAD |
| was_requested_at_least | None found | POTENTIALLY DEAD |
| was_requested_with_header | None found | POTENTIALLY DEAD |
| was_requested_with_body | None found | POTENTIALLY DEAD |
| was_requested_with_body_containing | None found | POTENTIALLY DEAD |
| was_get_requested | None found | POTENTIALLY DEAD |
| was_post_requested | None found | POTENTIALLY DEAD |
| was_put_requested | None found | POTENTIALLY DEAD |
| was_delete_requested | None found | POTENTIALLY DEAD |
| last_request_to | None found | POTENTIALLY DEAD |

**RESULT: No True Dead Code**

These features are PUBLIC API meant for external consumers. Not called internally but that's intentional - they're for test verification.

---

## INAPPROPRIATE INTIMACY SCAN

Detection criteria: Classes know too much about each other's internals

**Dependencies analyzed:**

| From | To | Access Type | Status |
|------|-----|-------------|--------|
| SIMPLE_MOCK | MOCK_SERVER | Public features | OK |
| SIMPLE_MOCK | MOCK_VERIFIER | Public features | OK |
| MOCK_VERIFIER | MOCK_SERVER | `received_requests`, `expectations` | OK - These are public |
| MOCK_EXPECTATION | MOCK_MATCHER | All features | OK - Intentional composition |
| MOCK_EXPECTATION | MOCK_RESPONSE | All features | OK - Intentional composition |

**RESULT: No Inappropriate Intimacy detected**

All inter-class access uses public features. No circular dependencies.

---

## SPECULATIVE GENERALITY SCAN

Detection criteria: Over-engineered for current needs

**Analysis:**

| Pattern | Used? | Status |
|---------|-------|--------|
| Deferred classes | No | OK - Not needed |
| Generic classes | No | OK - Domain-specific |
| Multiple response types | No | OK - MOCK_RESPONSE covers needs |
| Plugin system | No | OK - Not needed |

**RESULT: No Speculative Generality detected**

The library is appropriately minimal. No unnecessary abstractions.

---

## COMMENT SMELL SCAN

Detection criteria: Comments explaining what code does instead of why

### COMMENT SMELL: MOCK_MATCHER.matches_body:117

```eiffel
matches_body (a_body: STRING): BOOLEAN
    do
        Result := True
        if attached body_exact as l_exact then
            Result := a_body.same_string (l_exact)
        end
        if Result and attached body_contains as l_contains then
            Result := a_body.has_substring (l_contains)
        end
        -- JSON path matching would require simple_json integration
    end
```

**Comment:** "JSON path matching would require simple_json integration"
**Problem:** TODO comment in production code
**SEVERITY: LOW**

**RECOMMENDATION:** Either implement JSON path matching or remove the `json_path_requirements` attribute if it won't be used.

---

## High Severity Smells

**None detected.**

---

## Medium Severity Smells

### 1. Feature Envy in MOCK_VERIFIER

URL matching logic is duplicated across multiple verification features. Each one reimplements:
```eiffel
l_req.url.same_string (a_url) or l_req.url.has_substring (a_url)
```

**Impact:** Code duplication, inconsistent matching behavior possible
**Fix:** Add `matches_url_pattern` to MOCK_REQUEST or reuse MOCK_MATCHER

### 2. Primitive Obsession: HTTP Methods

No validation that HTTP method strings are valid.

**Impact:** Invalid methods accepted silently
**Fix:** Add validation in MOCK_MATCHER.make or use HTTP_METHOD class

---

## Low Severity Smells

1. **Data Clump:** Headers pattern duplicated (MOCK_REQUEST, MOCK_RESPONSE)
2. **Primitive Obsession:** Port as INTEGER (mitigated by contracts)
3. **Comment Smell:** TODO for JSON path matching

---

## Top Refactoring Opportunities

1. **Extract URL matching to shared location** (Medium effort, Medium impact)
   - Add `matches_pattern (a_pattern: STRING): BOOLEAN` to MOCK_REQUEST
   - Have MOCK_VERIFIER use MOCK_MATCHER for consistent matching

2. **Add HTTP method validation** (Low effort, Medium impact)
   - Add precondition in MOCK_MATCHER.make: `valid_http_method (a_method)`
   - Define valid methods: GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS

3. **Remove or implement JSON path matching** (Low effort, Low impact)
   - Remove `json_path_requirements` if not implementing
   - Or add simple_json dependency and implement

---

## Overall Assessment

**Design Quality: GOOD**

The simple_mock library has clean design with minimal smells:
- No God classes
- No long parameter lists
- No inappropriate intimacy
- No speculative generality
- No dead code

The 2 medium-severity issues (feature envy, primitive obsession) are addressable with small refactorings but don't block usage.

## Next Step
→ D03-INHERITANCE-AUDIT.md

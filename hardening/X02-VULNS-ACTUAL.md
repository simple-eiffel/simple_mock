# VULNERABILITY SCAN REPORT: simple_mock

## Scan Summary
- Total vulnerabilities: 12
- Critical: 0
- High: 4
- Medium: 5
- Low: 3

---

## NULL/VOID HAZARDS

### FINDING V01: MOCK_MATCHER.matches_body assumes non-void body
```eiffel
-- mock_matcher.e:107
matches_body (a_body: STRING): BOOLEAN
    do
        Result := True
        if attached body_exact as l_exact then
            Result := a_body.same_string (l_exact)  -- a_body could be Void!
```
- **Trigger**: Pass Void as a_body parameter
- **Severity**: HIGH
- **Note**: Parameter is non-detachable STRING, so Void safety protects us. VOID SAFE.

### FINDING V02: MOCK_REQUEST.body default empty string
```eiffel
-- mock_request.e:60-61
body: STRING
    -- Request body content
```
- Body is initialized to "" in make, always attached
- **Severity**: LOW (not a real vulnerability)

**Result: No actual void hazards due to Eiffel's void safety.**

---

## BOUNDARY VIOLATIONS

### FINDING V03: MOCK_REQUEST.path substring without bounds check
```eiffel
-- mock_request.e:38-40
l_pos := url.index_of ('?', 1)
if l_pos > 0 then
    Result := url.substring (1, l_pos - 1)
```
- **Trigger**: Empty URL would cause l_pos = 0, returns full URL (OK)
- **Severity**: LOW - index_of returns 0 if not found, substring handles this

### FINDING V04: MOCK_MATCHER.glob_matches boundary handling
```eiffel
-- mock_matcher.e:162
if l_pi <= a_pattern.count and then (a_pattern.item (l_pi) = '?' or a_pattern.item (l_pi) = a_text.item (l_ti)) then
```
- Pattern boundary checked before access
- **Severity**: LOW - properly guarded

**Result: No boundary violations found.**

---

## EMPTY INPUT HAZARDS

### FINDING V05: MOCK_EXPECTATION.make accepts empty strings despite contract
```eiffel
-- mock_expectation.e:17-19
require
    method_not_empty: not a_method.is_empty
    url_not_empty: not a_url.is_empty
```
- **Contracts exist** to prevent empty strings
- But shorthand features (expect_get, expect_post) DON'T validate
- **Trigger**: `mock.expect_get("")`
- **Severity**: HIGH
- Contracts propagate, so this will fail at MOCK_EXPECTATION.make

### FINDING V06: MOCK_MATCHER.make has NO contracts
```eiffel
-- mock_matcher.e:15-22
make (a_method: STRING; a_url_pattern: STRING)
    do
        method := a_method
        url_pattern := a_url_pattern
```
- **No preconditions** - accepts empty strings
- **Trigger**: `create matcher.make("", "")`
- Empty method will cause matches_method to always match anything
- Empty url_pattern will cause matches_url issues
- **Severity**: HIGH

### FINDING V07: MOCK_REQUEST.make has NO contracts
```eiffel
-- mock_request.e:15-23
make (a_method: STRING; a_url: STRING)
    do
        method := a_method
        url := a_url
```
- **No preconditions** - accepts empty strings
- **Severity**: MEDIUM

### FINDING V08: MOCK_RESPONSE.make has NO status code validation
```eiffel
-- mock_response.e:16-23
make (a_status: INTEGER)
    do
        status_code := a_status
```
- **No precondition** - accepts invalid status codes
- **Trigger**: `create response.make(-1)` or `create response.make(999999)`
- Valid HTTP status codes are 100-599
- **Severity**: MEDIUM

---

## STATE CORRUPTION

### FINDING V09: MOCK_SERVER.find_matching_expectation early exit bug
```eiffel
-- mock_server.e:132-136
across expectations as l_exp loop
    if l_exp.matches (a_request) then
        Result := l_exp
    end
end
```
- Loop continues even after finding match
- Last matching expectation returned, not first
- **Trigger**: Multiple matching expectations
- **Severity**: MEDIUM - behavior may not match user expectation

### FINDING V10: MOCK_REQUEST.set_query_string mutates url
```eiffel
-- mock_request.e:131-136
l_pos := url.index_of ('?', 1)
if l_pos > 0 then
    url := url.substring (1, l_pos - 1) + "?" + a_query
else
    url := url + "?" + a_query
end
```
- Creates new string but mutates `url` attribute
- If `url` was shared reference, other references see old value
- **Severity**: LOW - Eiffel strings are mutable, this is expected

---

## RESOURCE LEAKS

No resource leaks found. Library doesn't acquire external resources.

---

## TYPE CONFUSION

No type confusion found. No type casts used.

---

## CONCURRENCY HAZARDS

### FINDING V11: Shared mutable state without SCOOP protection
```eiffel
-- mock_server.e
expectations: ARRAYED_LIST [MOCK_EXPECTATION]
received_requests: ARRAYED_LIST [MOCK_REQUEST]
```
- These collections are mutable shared state
- No SCOOP separate annotations
- **Trigger**: Concurrent access from multiple threads
- **Severity**: MEDIUM (library is SCOOP-configured, but classes not separate)
- **Note**: For mock server used in tests, single-threaded access is typical

---

## INJECTION HAZARDS

No injection hazards found. Library doesn't execute external commands or queries.

---

## LOGIC ERRORS

### FINDING V12: MOCK_MATCHER.matches_url substring match is too permissive
```eiffel
-- mock_matcher.e:72-73
else
    Result := a_url.same_string (url_pattern) or else a_url.has_substring (url_pattern)
```
- Pattern "/api" would match "/other/api/users" (has_substring returns True)
- **Expected**: Pattern should match from start or use glob
- **Trigger**: Pattern "/api" matches URL "/v2/api/users"
- **Severity**: MEDIUM - may match unintended URLs

---

## CONTRACT GAPS

### GAP 1: MOCK_MATCHER (NO CONTRACTS)
- Should have: `require method_not_empty, url_pattern_not_empty`
- Risk: Invalid matcher created, all matches return False or True incorrectly

### GAP 2: MOCK_REQUEST (NO CONTRACTS)
- Should have: `require method_not_empty, url_not_empty`
- Risk: Invalid request objects

### GAP 3: MOCK_RESPONSE (NO CONTRACTS)
- Should have: `require valid_status_code: status >= 100 and status <= 599`
- Risk: Invalid HTTP status codes

### GAP 4: MOCK_VERIFIER (NO CONTRACTS)
- Should have: Postconditions verifying query results
- Risk: Lower priority, queries don't modify state

### GAP 5: SIMPLE_MOCK.expect_* shorthand methods
- Should have: `require url_not_empty`
- Risk: Empty URL propagates to MOCK_EXPECTATION which will fail

---

## Critical Findings

**None.**

---

## High Findings

| ID | Location | Pattern | Impact |
|----|----------|---------|--------|
| V05 | SIMPLE_MOCK.expect_get/post/etc | Empty input not validated | Contract violation at MOCK_EXPECTATION |
| V06 | MOCK_MATCHER.make | No contracts | Invalid matcher accepts everything |

---

## Medium Findings

| ID | Location | Pattern | Impact |
|----|----------|---------|--------|
| V07 | MOCK_REQUEST.make | No contracts | Invalid requests accepted |
| V08 | MOCK_RESPONSE.make | Invalid status codes | Non-HTTP status codes accepted |
| V09 | MOCK_SERVER.find_matching | Returns last match not first | Behavior surprise |
| V11 | MOCK_SERVER state | Concurrency unsafe | Race conditions possible |
| V12 | MOCK_MATCHER.matches_url | Too permissive | Unintended URL matches |

---

## Low Findings

| ID | Location | Pattern | Impact |
|----|----------|---------|--------|
| V02 | MOCK_REQUEST.body | Default empty | Not a bug |
| V03 | MOCK_REQUEST.path | Bounds handling | Properly handled |
| V10 | MOCK_REQUEST.set_query_string | String mutation | Expected behavior |

---

## Attack Plan

Based on vulnerabilities found:

1. **First assault**: Add contracts to MOCK_MATCHER.make - will expose callers passing empty strings
2. **Second assault**: Add contracts to MOCK_RESPONSE.make - will validate status codes
3. **Third assault**: Fix MOCK_SERVER.find_matching to return first match
4. **Fourth assault**: Add contracts to SIMPLE_MOCK.expect_* methods
5. **Fifth assault**: Tighten MOCK_MATCHER.matches_url logic

---

## Recommended Defenses

```eiffel
-- MOCK_MATCHER.make
require
    method_not_empty: not a_method.is_empty
    url_pattern_not_empty: not a_url_pattern.is_empty
    valid_http_method: valid_http_method (a_method)

-- MOCK_RESPONSE.make
require
    valid_status: a_status >= 100 and a_status <= 599

-- MOCK_REQUEST.make
require
    method_not_empty: not a_method.is_empty
    url_not_empty: not a_url.is_empty

-- SIMPLE_MOCK.expect_get etc
require
    url_not_empty: not a_url.is_empty
```

## Next Step
→ X03-CONTRACT-ASSAULT.md

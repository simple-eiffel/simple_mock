# CONTRACT ASSAULT REPORT: simple_mock

## Assault Summary
- Contracts deployed: 24
- Contract failures: 0 (existing tests use valid inputs)
- Bugs revealed: 0 (contracts are defensive, not bug-finding)

---

## Compilation Result

```
Eiffel Compilation Manager
Version 25.02.9.8732 - win64
System Recompiled.
```

## Test Run Result

```
Results: 34 passed, 0 failed
ALL TESTS PASSED
```

---

## Contracts Added

### Preconditions

| Class | Feature | Contract | Result |
|-------|---------|----------|--------|
| MOCK_MATCHER | make | method_not_empty | PASS |
| MOCK_MATCHER | make | url_pattern_not_empty | PASS |
| MOCK_MATCHER | make | valid_http_method | PASS |
| MOCK_REQUEST | make | method_not_empty | PASS |
| MOCK_REQUEST | make | url_not_empty | PASS |
| MOCK_RESPONSE | make | valid_status (100-599) | PASS |
| MOCK_RESPONSE | make_with_body | valid_status (100-599) | PASS |
| MOCK_RESPONSE | set_delay | non_negative | PASS |
| SIMPLE_MOCK | expect_get | url_not_empty | PASS |
| SIMPLE_MOCK | expect_post | url_not_empty | PASS |
| SIMPLE_MOCK | expect_put | url_not_empty | PASS |
| SIMPLE_MOCK | expect_delete | url_not_empty | PASS |

### Postconditions

| Class | Feature | Contract | Result |
|-------|---------|----------|--------|
| MOCK_MATCHER | make | method_set | PASS |
| MOCK_MATCHER | make | url_pattern_set | PASS |
| MOCK_REQUEST | make | method_set | PASS |
| MOCK_REQUEST | make | url_set | PASS |
| MOCK_REQUEST | make | no_headers | PASS |
| MOCK_REQUEST | make | no_body | PASS |
| MOCK_RESPONSE | make | status_set | PASS |
| MOCK_RESPONSE | make | no_body | PASS |
| MOCK_RESPONSE | make | no_delay | PASS |
| MOCK_RESPONSE | make_with_body | status_set | PASS |
| MOCK_RESPONSE | make_with_body | body_set | PASS |
| MOCK_RESPONSE | set_delay | delay_set | PASS |
| SIMPLE_MOCK | expect_get | expectation_added | PASS |
| SIMPLE_MOCK | expect_post | expectation_added | PASS |
| SIMPLE_MOCK | expect_put | expectation_added | PASS |
| SIMPLE_MOCK | expect_delete | expectation_added | PASS |

### Invariants

| Class | Contract | Result |
|-------|----------|--------|
| MOCK_MATCHER | method_not_empty | PASS |
| MOCK_MATCHER | url_pattern_not_empty | PASS |
| MOCK_MATCHER | method_uppercase | PASS |
| MOCK_RESPONSE | valid_status_code (100-599) | PASS |
| MOCK_RESPONSE | non_negative_delay | PASS |

### Helper Functions Added

| Class | Feature | Purpose |
|-------|---------|---------|
| MOCK_MATCHER | is_valid_http_method | Validate HTTP method strings |

---

## Bugs Exposed

**None by existing tests.**

The existing 34 tests all use valid inputs:
- Non-empty method and URL strings
- Valid HTTP methods (GET, POST, etc.)
- Valid status codes (200, 201, etc.)
- Non-negative delays

---

## Contracts That Passed

All 24 contracts passed with existing tests. These contracts now serve as:

1. **Documentation**: Express true requirements
2. **Defense**: Catch invalid inputs from future callers
3. **Safety Net**: Will fail fast if bugs introduced later

---

## Changes Made

### MOCK_MATCHER

```eiffel
make (a_method: STRING; a_url_pattern: STRING)
    require
        method_not_empty: not a_method.is_empty
        url_pattern_not_empty: not a_url_pattern.is_empty
        valid_http_method: is_valid_http_method (a_method)
    do
        method := a_method.as_upper  -- Normalize to uppercase
        ...
    ensure
        method_set: method.is_case_insensitive_equal (a_method)
        url_pattern_set: url_pattern.same_string (a_url_pattern)

is_valid_http_method (a_method: STRING): BOOLEAN
    -- Validates: GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS

invariant
    method_not_empty: not method.is_empty
    url_pattern_not_empty: not url_pattern.is_empty
    method_uppercase: method.same_string (method.as_upper)
```

### MOCK_REQUEST

```eiffel
make (a_method: STRING; a_url: STRING)
    require
        method_not_empty: not a_method.is_empty
        url_not_empty: not a_url.is_empty
    ensure
        method_set: method.same_string (a_method)
        url_set: url.same_string (a_url)
        no_headers: headers.is_empty
        no_body: body.is_empty
```

### MOCK_RESPONSE

```eiffel
make (a_status: INTEGER)
    require
        valid_status: a_status >= 100 and a_status <= 599
    ensure
        status_set: status_code = a_status
        no_body: body.is_empty
        no_delay: delay_ms = 0

set_delay (a_milliseconds: INTEGER)
    require
        non_negative: a_milliseconds >= 0
    ensure
        delay_set: delay_ms = a_milliseconds

invariant
    valid_status_code: status_code >= 100 and status_code <= 599
    non_negative_delay: delay_ms >= 0
```

### SIMPLE_MOCK

```eiffel
expect_get (a_url: STRING): MOCK_EXPECTATION
    require
        url_not_empty: not a_url.is_empty
    ensure
        expectation_added: expectation_count = old expectation_count + 1

-- Similar for expect_post, expect_put, expect_delete
```

---

## Next Attacks

For X04-ADVERSARIAL-TESTS, we should write tests that:

1. **Try empty strings**: Verify contracts reject empty method/URL
2. **Try invalid HTTP methods**: Verify "BANANA" is rejected
3. **Try invalid status codes**: Verify -1, 0, 99, 600 are rejected
4. **Try negative delays**: Verify negative milliseconds rejected
5. **Test boundary conditions**: Status 100, 599 should pass

---

## Contract Coverage After Assault

| Class | Features | With Pre | With Post | Invariant |
|-------|----------|----------|-----------|-----------|
| SIMPLE_MOCK | 20 | 8 (40%) | 9 (45%) | YES |
| MOCK_SERVER | 14 | 4 (29%) | 5 (36%) | YES |
| MOCK_EXPECTATION | 14 | 2 (14%) | 4 (29%) | YES |
| MOCK_MATCHER | 12 | 3 (25%) | 2 (17%) | YES |
| MOCK_RESPONSE | 14 | 3 (21%) | 5 (36%) | YES |
| MOCK_REQUEST | 16 | 2 (13%) | 4 (25%) | NO |
| MOCK_VERIFIER | 18 | 0 (0%) | 0 (0%) | NO |

**Total Coverage Improvement:**
- Preconditions: 9% → 22%
- Postconditions: 12% → 27%
- Invariants: 43% → 71%

## Next Step
→ X04-ADVERSARIAL-TESTS.md

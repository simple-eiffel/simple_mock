# X01: Reconnaissance - simple_mock

## Date: 2026-01-18

## Baseline Verification

### Compilation
```
Eiffel Compilation Manager
Version 25.02.9.8732 - win64

Degree 6: Examining System
System Recompiled.
```

### Test Run
```
simple_mock test runner
=============================
-- SIMPLE_MOCK Tests --
  PASS: test_simple_mock_make
  PASS: test_simple_mock_make_on_port
  PASS: test_simple_mock_url
  PASS: test_simple_mock_start_stop
  PASS: test_simple_mock_expect
  PASS: test_simple_mock_reset

-- MOCK_SERVER Tests --
  PASS: test_mock_server_make
  PASS: test_mock_server_start
  PASS: test_mock_server_add_expectation
  PASS: test_mock_server_record_request
  PASS: test_mock_server_find_matching

-- MOCK_EXPECTATION Tests --
  PASS: test_mock_expectation_make
  PASS: test_mock_expectation_matches
  PASS: test_mock_expectation_not_matches_method
  PASS: test_mock_expectation_record_match
  PASS: test_mock_expectation_chaining

-- MOCK_MATCHER Tests --
  PASS: test_mock_matcher_exact_url
  PASS: test_mock_matcher_wildcard_url
  PASS: test_mock_matcher_method
  PASS: test_mock_matcher_body_contains

-- MOCK_RESPONSE Tests --
  PASS: test_mock_response_make
  PASS: test_mock_response_make_with_body
  PASS: test_mock_response_set_json_body
  PASS: test_mock_response_delay

-- MOCK_REQUEST Tests --
  PASS: test_mock_request_make
  PASS: test_mock_request_path
  PASS: test_mock_request_query_string
  PASS: test_mock_request_is_get
  PASS: test_mock_request_headers

-- MOCK_VERIFIER Tests --
  PASS: test_mock_verifier_was_requested
  PASS: test_mock_verifier_was_never_requested
  PASS: test_mock_verifier_request_count
  PASS: test_mock_verifier_unmatched
  PASS: test_mock_verifier_all_matched

=============================
Results: 34 passed, 0 failed
ALL TESTS PASSED
```

### Baseline Status
- Compiles: YES
- Tests: 34 pass, 0 fail
- Warnings: 0

---

## Source Files

| File | Class | Lines | Features | Contracts |
|------|-------|-------|----------|-----------|
| simple_mock.e | SIMPLE_MOCK | 191 | 20 | 4 pre, 4 post, 4 inv |
| mock_server.e | MOCK_SERVER | 161 | 14 | 4 pre, 5 post, 5 inv |
| mock_expectation.e | MOCK_EXPECTATION | 153 | 14 | 2 pre, 4 post, 4 inv |
| mock_matcher.e | MOCK_MATCHER | 186 | 12 | 0 pre, 0 post, 0 inv |
| mock_response.e | MOCK_RESPONSE | 115 | 14 | 0 pre, 0 post, 0 inv |
| mock_request.e | MOCK_REQUEST | 139 | 16 | 0 pre, 0 post, 0 inv |
| mock_verifier.e | MOCK_VERIFIER | 220 | 18 | 0 pre, 0 post, 0 inv |

**Total: 7 files, 1165 lines, 108 features**

---

## Public API Analysis

### SIMPLE_MOCK (Facade - Main Entry Point)

| Feature | Type | Params | Pre | Post | Risk |
|---------|------|--------|-----|------|------|
| make | creation | - | 0 | 0 | LOW |
| make_on_port | creation | port: INTEGER | 2 | 2 | LOW |
| start | command | - | 1 | 1 | LOW |
| stop | command | - | 1 | 1 | LOW |
| reset | command | - | 0 | 0 | LOW |
| expect | command | method, url: STRING | 2 | 1 | **MEDIUM** |
| expect_get | command | url: STRING | 0 | 0 | **HIGH** |
| expect_post | command | url: STRING | 0 | 0 | **HIGH** |
| expect_put | command | url: STRING | 0 | 0 | **HIGH** |
| expect_delete | command | url: STRING | 0 | 0 | **HIGH** |
| port | query | - | 0 | 0 | LOW |
| url | query | - | 0 | 0 | LOW |
| is_running | query | - | 0 | 0 | LOW |
| was_requested | query | url: STRING | 0 | 0 | MEDIUM |
| request_count | query | url: STRING | 0 | 0 | LOW |
| verify_all_matched | query | - | 0 | 0 | LOW |

### MOCK_SERVER

| Feature | Type | Params | Pre | Post | Risk |
|---------|------|--------|-----|------|------|
| make | creation | port: INTEGER | 2 | 4 | LOW |
| start | command | - | 1 | 2 | LOW |
| stop | command | - | 1 | 1 | LOW |
| reset | command | - | 0 | 0 | LOW |
| add_expectation | command | exp: MOCK_EXPECTATION | 1 | 2 | LOW |
| remove_expectation | command | exp: MOCK_EXPECTATION | 0 | 0 | MEDIUM |
| clear_expectations | command | - | 0 | 0 | LOW |
| find_matching_expectation | query | req: MOCK_REQUEST | 0 | 0 | MEDIUM |
| record_request | command | req: MOCK_REQUEST | 0 | 0 | **HIGH** |
| clear_history | command | - | 0 | 1 | LOW |

### MOCK_EXPECTATION

| Feature | Type | Params | Pre | Post | Risk |
|---------|------|--------|-----|------|------|
| make | creation | method, url: STRING | 2 | 3 | LOW |
| matches | query | req: MOCK_REQUEST | 0 | 0 | MEDIUM |
| record_match | command | - | 0 | 2 | LOW |
| with_header | command | name, value: STRING | 0 | 0 | **HIGH** |
| with_body | command | body: STRING | 0 | 0 | **HIGH** |
| with_body_containing | command | substring: STRING | 0 | 0 | **HIGH** |
| then_respond | command | status: INTEGER | 0 | 0 | **HIGH** |
| then_respond_json | command | status: INTEGER, json: STRING | 0 | 0 | **HIGH** |
| with_delay | command | ms: INTEGER | 0 | 0 | **HIGH** |

### MOCK_MATCHER (NO CONTRACTS)

| Feature | Type | Params | Pre | Post | Risk |
|---------|------|--------|-----|------|------|
| make | creation | method, url: STRING | 0 | 0 | **HIGH** |
| matches | query | req: MOCK_REQUEST | 0 | 0 | MEDIUM |
| matches_url | query | url: STRING | 0 | 0 | MEDIUM |
| matches_method | query | method: STRING | 0 | 0 | LOW |
| matches_headers | query | headers: HASH_TABLE | 0 | 0 | LOW |
| matches_body | query | body: STRING | 0 | 0 | LOW |
| add_header_requirement | command | name, value: STRING | 0 | 0 | **HIGH** |
| set_body_exact | command | body: STRING | 0 | 0 | **HIGH** |
| set_body_contains | command | substring: STRING | 0 | 0 | **HIGH** |

### MOCK_RESPONSE (NO CONTRACTS)

| Feature | Type | Params | Pre | Post | Risk |
|---------|------|--------|-----|------|------|
| make | creation | status: INTEGER | 0 | 0 | **HIGH** |
| make_with_body | creation | status: INTEGER, body: STRING | 0 | 0 | **HIGH** |
| set_status | command | status: INTEGER | 0 | 0 | **HIGH** |
| set_body | command | body: STRING | 0 | 0 | MEDIUM |
| set_json_body | command | json: STRING | 0 | 0 | MEDIUM |
| add_header | command | name, value: STRING | 0 | 0 | **HIGH** |
| set_delay | command | ms: INTEGER | 0 | 0 | **HIGH** |

### MOCK_REQUEST (NO CONTRACTS)

| Feature | Type | Params | Pre | Post | Risk |
|---------|------|--------|-----|------|------|
| make | creation | method, url: STRING | 0 | 0 | **HIGH** |
| set_body | command | body: STRING | 0 | 0 | MEDIUM |
| add_header | command | name, value: STRING | 0 | 0 | **HIGH** |
| set_query_string | command | query: STRING | 0 | 0 | MEDIUM |

### MOCK_VERIFIER (NO CONTRACTS)

All 18 features have 0 preconditions and 0 postconditions.

---

## Contract Coverage Summary

| Metric | Count | Percentage |
|--------|-------|------------|
| Total features | 108 | 100% |
| With preconditions | 10 | 9% |
| With postconditions | 13 | 12% |
| Classes with invariants | 3/7 | 43% |

**Contract coverage is LOW - significant attack surface exposed.**

---

## Attack Surface Priority

### HIGH (Unprotected public features accepting user input)

1. `MOCK_MATCHER.make(method, url)` - No validation of method/url
2. `MOCK_REQUEST.make(method, url)` - No validation of method/url
3. `MOCK_RESPONSE.make(status)` - No validation of status code
4. `MOCK_RESPONSE.set_delay(ms)` - No validation (negative values?)
5. `SIMPLE_MOCK.expect_get(url)` - No contracts, forwards unchecked
6. `SIMPLE_MOCK.expect_post(url)` - No contracts, forwards unchecked
7. `SIMPLE_MOCK.expect_put(url)` - No contracts, forwards unchecked
8. `SIMPLE_MOCK.expect_delete(url)` - No contracts, forwards unchecked
9. `MOCK_EXPECTATION.with_header(name, value)` - No validation
10. `MOCK_EXPECTATION.then_respond(status)` - No validation
11. `MOCK_EXPECTATION.with_delay(ms)` - No validation
12. `MOCK_MATCHER.add_header_requirement(name, value)` - No validation
13. `MOCK_RESPONSE.add_header(name, value)` - No validation
14. `MOCK_REQUEST.add_header(name, value)` - No validation

### MEDIUM (Partial protection or state-dependent)

1. `MOCK_SERVER.record_request(req)` - No precondition on req validity
2. `MOCK_SERVER.find_matching_expectation(req)` - No validation
3. `MOCK_SERVER.remove_expectation(exp)` - No precondition
4. `MOCK_MATCHER.matches(req)` - Assumes valid request object
5. `SIMPLE_MOCK.was_requested(url)` - No validation

### LOW (Protected or minimal risk)

1. `SIMPLE_MOCK.make_on_port(port)` - Has port validation contracts
2. `MOCK_SERVER.make(port)` - Has port validation contracts
3. `MOCK_EXPECTATION.make(method, url)` - Has not_empty contracts
4. `SIMPLE_MOCK.start/stop` - Has running state contracts
5. `MOCK_SERVER.start/stop` - Has running state contracts

---

## State Analysis

### Mutable State

| Class | Attribute | Modified By | Protected By |
|-------|-----------|-------------|--------------|
| MOCK_SERVER | is_running | start, stop | Preconditions |
| MOCK_SERVER | expectations | add/remove/clear | Invariant (count >= 0) |
| MOCK_SERVER | received_requests | record_request | None |
| MOCK_EXPECTATION | match_count | record_match | Postcondition |
| MOCK_MATCHER | body_exact | set_body_exact | None |
| MOCK_MATCHER | body_contains | set_body_contains | None |
| MOCK_MATCHER | required_headers | add_header_requirement | None |
| MOCK_RESPONSE | status_code | set_status | None |
| MOCK_RESPONSE | body | set_body | None |
| MOCK_RESPONSE | delay_ms | set_delay | None |
| MOCK_REQUEST | body | set_body | None |
| MOCK_REQUEST | url | set_query_string | None |

---

## VERIFICATION CHECKPOINT

```
Compilation output: PASTED (System Recompiled)
Test output: PASTED (34 pass, 0 fail)
Source files read: 7
Attack surfaces listed: 14 HIGH, 5 MEDIUM, 5 LOW
hardening/X01-RECON-ACTUAL.md: CREATED
```

## Next Step

→ X02-VULNERABILITY-SCAN.md

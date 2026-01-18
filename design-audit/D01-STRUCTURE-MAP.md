# STRUCTURE ANALYSIS: simple_mock

## Summary
- Classes: 7
- Max inheritance depth: 1 (all inherit directly from ANY)
- Average features per class: 16
- Generic classes: 0 (0%)
- Deferred classes: 0 (0%)

## Inheritance Hierarchy

```
ANY
 ├── SIMPLE_MOCK (facade)
 ├── MOCK_SERVER (server management)
 ├── MOCK_EXPECTATION (request-response pairing)
 ├── MOCK_MATCHER (URL/header/body matching)
 ├── MOCK_RESPONSE (response definition)
 ├── MOCK_REQUEST (received request record)
 └── MOCK_VERIFIER (assertion helpers)
```

INHERITANCE METRICS:
- Total classes: 7
- Max depth: 1
- Classes with multiple parents: 0
- Root classes (direct from ANY): 7

## Dependency Map

```
┌─────────────┐
│ SIMPLE_MOCK │ (FACADE)
└──────┬──────┘
       │ creates/uses
       ├─────────────────────┐
       ▼                     ▼
┌─────────────┐      ┌──────────────┐
│ MOCK_SERVER │      │ MOCK_VERIFIER│
└──────┬──────┘      └──────┬───────┘
       │ uses                │ uses
       ├──────────┐          │
       ▼          ▼          │
┌────────────┐ ┌────────────┐│
│MOCK_REQUEST│ │MOCK_EXPECT.││
└────────────┘ └─────┬──────┘│
                     │       │
              ┌──────┴─────┐ │
              ▼            ▼ │
       ┌─────────────┐ ┌─────┴──────┐
       │MOCK_MATCHER │ │MOCK_RESPONSE│
       └─────────────┘ └────────────┘
```

## Class Inventory

| Class | LOC | Features | Inherits | Depth | Ce (Efferent) |
|-------|-----|----------|----------|-------|---------------|
| SIMPLE_MOCK | 191 | 20 | ANY | 1 | 3 (SERVER, VERIFIER, EXPECTATION) |
| MOCK_SERVER | 161 | 14 | ANY | 1 | 2 (EXPECTATION, REQUEST) |
| MOCK_EXPECTATION | 153 | 14 | ANY | 1 | 2 (MATCHER, RESPONSE) |
| MOCK_MATCHER | 186 | 12 | ANY | 1 | 1 (REQUEST) |
| MOCK_RESPONSE | 115 | 14 | ANY | 1 | 0 |
| MOCK_REQUEST | 139 | 16 | ANY | 1 | 0 |
| MOCK_VERIFIER | 220 | 18 | ANY | 1 | 3 (SERVER, EXPECTATION, REQUEST) |

## Feature Distribution

| Class | Queries | Commands | Attributes | Total |
|-------|---------|----------|------------|-------|
| SIMPLE_MOCK | 11 | 6 | 2 | 20 |
| MOCK_SERVER | 8 | 6 | 4 | 14 |
| MOCK_EXPECTATION | 6 | 8 | 3 | 14 |
| MOCK_MATCHER | 7 | 4 | 5 | 12 |
| MOCK_RESPONSE | 6 | 6 | 4 | 14 |
| MOCK_REQUEST | 12 | 3 | 5 | 16 |
| MOCK_VERIFIER | 17 | 0 | 2 | 18 |

## Client/Supplier Analysis

### SUPPLIERS (provide services):
- MOCK_SERVER: Server lifecycle, expectation management, request recording
- MOCK_EXPECTATION: Request matching rules, response definition
- MOCK_MATCHER: URL/header/body pattern matching
- MOCK_RESPONSE: HTTP response configuration
- MOCK_REQUEST: Request data access
- MOCK_VERIFIER: Verification queries

### CLIENTS (consume services):
- SIMPLE_MOCK: Main facade consuming SERVER, VERIFIER
- MOCK_VERIFIER: Consumes SERVER, EXPECTATION, REQUEST

### FACADE IDENTIFICATION:
- Main entry point: SIMPLE_MOCK
- Internal only: MOCK_MATCHER (used only by MOCK_EXPECTATION)

## Cohesion Analysis

### SIMPLE_MOCK
- Group 1: Creation (make, make_on_port) - initialization
- Group 2: Server control (start, stop, reset) - lifecycle
- Group 3: Expectation building (expect, expect_get, ...) - configuration
- Group 4: Verification (was_requested, verify_all_matched) - testing
**Assessment: 4 responsibilities - MODERATE concern**

### MOCK_VERIFIER
- Group 1: URL assertions (was_requested, was_never_requested, was_requested_times)
- Group 2: Method assertions (was_get_requested, was_post_requested, ...)
- Group 3: Detail assertions (was_requested_with_header, was_requested_with_body)
- Group 4: Expectation assertions (all_expectations_matched, unmatched_expectations)
- Group 5: Request counting (request_count, request_count_for_method)
- Group 6: Request access (requests_to, last_request_to)
**Assessment: All related to verification - GOOD cohesion**

### MOCK_REQUEST
- Group 1: Access (method, url, path, query_string)
- Group 2: Status (is_get, is_post, has_body, has_header)
- Group 3: Configuration (set_body, add_header, set_query_string)
**Assessment: Single responsibility - GOOD cohesion**

## Potential Design Issues (Initial)

### 1. No Genericity
- All collections use concrete ARRAYED_LIST types
- No type parameterization
**Impact: LOW - Domain-specific library, genericity not beneficial**

### 2. MOCK_VERIFIER Size
- 220 lines, 18 features
- Largest class in library
**Impact: LOW - All features related to verification**

### 3. SIMPLE_MOCK Multiple Responsibilities
- Facade handling creation, control, configuration, AND verification
**Impact: MEDIUM - Could delegate more to internal classes**

### 4. No Deferred Classes
- No abstract interfaces defined
- All classes are concrete
**Impact: LOW - Small, focused library**

### 5. Missing Contracts
- MOCK_VERIFIER has no preconditions/postconditions
- MOCK_REQUEST has no contracts
- MOCK_RESPONSE has no contracts
**Impact: MEDIUM - DBC incomplete**

## Visualization

```
                    ┌─────────────────────────────────────┐
                    │           SIMPLE_MOCK               │
                    │ (Facade - Main Entry Point)         │
                    │                                     │
                    │  port, url, is_running              │
                    │  start, stop, reset                 │
                    │  expect_*, was_requested            │
                    └───────────────┬─────────────────────┘
                                    │
            ┌───────────────────────┼───────────────────────┐
            │                       │                       │
            ▼                       ▼                       ▼
    ┌───────────────┐      ┌───────────────┐      ┌───────────────┐
    │  MOCK_SERVER  │      │MOCK_EXPECTATION│     │ MOCK_VERIFIER │
    │               │      │               │      │               │
    │ expectations  │◄─────│ matcher       │      │ was_requested │
    │ requests      │      │ response      │      │ request_count │
    │ start/stop    │      │ matches()     │      │ all_matched   │
    └───────┬───────┘      └───────┬───────┘      └───────────────┘
            │                      │
            │              ┌───────┴───────┐
            │              │               │
            ▼              ▼               ▼
    ┌───────────────┐ ┌───────────────┐ ┌───────────────┐
    │ MOCK_REQUEST  │ │ MOCK_MATCHER  │ │ MOCK_RESPONSE │
    │               │ │               │ │               │
    │ method, url   │ │ matches()     │ │ status_code   │
    │ headers, body │ │ glob_matches  │ │ body, headers │
    │ path, query   │ │ body_contains │ │ delay_ms      │
    └───────────────┘ └───────────────┘ └───────────────┘
```

## Next Step
→ D02-SMELL-DETECTION.md

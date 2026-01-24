# S06: BOUNDARIES - simple_mock

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mock

## System Boundaries

```
+------------------+               +------------------+
|   Test Code      | <----------> |   SIMPLE_MOCK    |
|                  |   Eiffel API |   (Facade)       |
+------------------+               +------------------+
                                          |
                                          v
                                   +------------------+
                                   |   MOCK_SERVER    |
                                   |   - Expectations |
                                   |   - History      |
                                   +------------------+
                                          |
                     +--------------------+--------------------+
                     |                    |                    |
                     v                    v                    v
            +---------------+    +---------------+    +---------------+
            | MOCK_         |    | MOCK_         |    | MOCK_         |
            | EXPECTATION   |    | REQUEST       |    | VERIFIER      |
            +---------------+    +---------------+    +---------------+
```

## External Interfaces

### Input Boundaries

| Interface | Format | Source |
|-----------|--------|--------|
| Expectations | Fluent API calls | Test code |
| Requests | MOCK_REQUEST objects | (future: HTTP) |
| Verification queries | Method calls | Test code |

### Output Boundaries

| Interface | Format | Destination |
|-----------|--------|-------------|
| Responses | MOCK_RESPONSE | (future: HTTP) |
| Verification results | Boolean/List | Test code |
| Model queries | MML_SEQUENCE | Test contracts |

## Class Relationships

```
SIMPLE_MOCK (facade)
    |
    +-- MOCK_SERVER (1:1)
          |
          +-- MOCK_EXPECTATION (1:n)
          |     |
          |     +-- MOCK_RESPONSE (1:1)
          |
          +-- MOCK_REQUEST (1:n, history)
          |
          +-- MOCK_VERIFIER (1:1)
                |
                +-- MOCK_MATCHER (uses)
```

## Model Query Boundaries

### model_expectations
- Returns: MML_SEQUENCE [MOCK_EXPECTATION]
- Content: Copy of current expectations
- Immutable view

### model_received_requests
- Returns: MML_SEQUENCE [MOCK_REQUEST]
- Content: Copy of request history
- Immutable view

## Trust Boundaries

### Trusted
- Test code (configures expectations)
- simple_mml (model types)
- Base library

### Untrusted
- (future: HTTP request content)
- External port availability

## Versioning

- Library version: 1.0
- Model types: simple_mml
- HTTP support: Future

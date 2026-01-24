# 7S-04: SIMPLE-STAR - simple_mock

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mock

## Ecosystem Dependencies

### Required simple_* Libraries

| Library | Purpose | Version |
|---------|---------|---------|
| simple_mml | Model types for DBC | latest |

### ISE Base Libraries Used

| Library | Purpose |
|---------|---------|
| base | ARRAYED_LIST, HASH_TABLE |

## Integration Points

### simple_mml Integration
- MML_SEQUENCE [MOCK_EXPECTATION] for model_expectations
- MML_SEQUENCE [MOCK_REQUEST] for model_received_requests
- Enables DBC postconditions in tests

### simple_http Integration (future)
- Mock server would handle simple_http requests
- Intercept at HTTP layer
- Currently works conceptually

## Ecosystem Fit

### Category
Testing / HTTP Mocking

### Phase
Phase 3 - Core functionality

### Maturity
Functional (needs HTTP integration)

### Consumers
- Test suites for HTTP clients
- Integration tests
- Service testing

## Usage Patterns

### Basic Setup
```eiffel
create mock.make
mock.expect_get ("/api/users").respond_with_json ("[{...}]")
mock.start
-- run client code
assert ("called", mock.was_requested ("/api/users"))
mock.stop
```

### Multiple Expectations
```eiffel
mock.expect_get ("/api/users").respond_with_status (200)
mock.expect_post ("/api/users").respond_with_status (201)
mock.expect_delete ("/api/users/1").respond_with_status (204)
```

### Verification
```eiffel
assert ("all matched", mock.verify_all_matched)
assert ("two calls", mock.request_count ("/api/users") = 2)
```

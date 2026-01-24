# S01: PROJECT INVENTORY - simple_mock

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mock

## Project Structure

```
simple_mock/
  src/
    simple_mock.e              # Main facade class
    mock_server.e              # Core server logic
    mock_expectation.e         # Request/response expectation
    mock_request.e             # Captured request data
    mock_response.e            # Configured response data
    mock_verifier.e            # Verification logic
    mock_matcher.e             # Request matching
    mock_server_pool.e         # Connection pool
  testing/
    test_app.e                 # Test application entry
    test_runner.e              # Test runner
    lib_tests.e                # Test suite
    test_person.e              # Test data class
    adversarial_tests.e        # Edge case tests
  research/                    # 7S research documents
  specs/                       # Specification documents
  simple_mock.ecf              # Library ECF configuration
```

## File Counts

| Category | Count |
|----------|-------|
| Source (.e) | 13 |
| Configuration (.ecf) | 1 |
| Documentation (.md) | 15+ |

## Dependencies

### simple_* Ecosystem
- simple_mml (model types)

### ISE Libraries
- base (ARRAYED_LIST, HASH_TABLE)

## Build Targets

| Target | Type | Purpose |
|--------|------|---------|
| simple_mock | library | Reusable library |
| simple_mock_tests | executable | Test suite |

## Version

Current: 1.0

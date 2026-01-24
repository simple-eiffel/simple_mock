# 7S-02: STANDARDS - simple_mock

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mock

## Applicable Standards

### HTTP/1.1 (RFC 7230-7235)
- **Source**: IETF
- **Relevance**: HTTP protocol semantics
- **Compliance**: Models standard HTTP concepts

### REST Principles
- **Source**: Roy Fielding dissertation
- **Relevance**: Resource-based URL patterns
- **Compliance**: Supports RESTful expectations

### xUnit Test Patterns
- **Source**: Gerard Meszaros
- **Pattern**: Test Double (Mock Object)
- **Compliance**: Implements mock server pattern

## Design Patterns

### Builder Pattern
- MOCK_EXPECTATION uses fluent interface
- Method chaining for readable setup
- Returns Current for continuation

### Facade Pattern
- SIMPLE_MOCK as main entry point
- Hides internal server complexity
- Simple API for common operations

### Observer Pattern (implicit)
- Server records all requests
- Verifier analyzes request history

## Coding Standards

- Design by Contract throughout
- SCOOP compatibility
- Model queries using simple_mml
- Pure Eiffel implementation

## Test Integration

### Assertion Support
```eiffel
assert ("all matched", mock.verify_all_matched)
assert ("endpoint called", mock.was_requested ("/api/users"))
```

### Verification Queries
- was_requested: Check if URL was called
- request_count: Number of calls to URL
- verify_all_matched: All expectations satisfied
- unmatched_expectations: List of unfulfilled expectations

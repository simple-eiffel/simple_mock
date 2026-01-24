# 7S-06: SIZING - simple_mock


**Date**: 2026-01-23

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mock

## Codebase Metrics

### Source Files
- **Total Classes**: 13
- **Main Source**: 8 classes in src/
- **Testing**: 5 classes in testing/

### Lines of Code
- SIMPLE_MOCK: ~240 LOC
- MOCK_SERVER: ~220 LOC
- MOCK_EXPECTATION: ~200 LOC
- MOCK_REQUEST: ~100 LOC
- MOCK_RESPONSE: ~100 LOC
- MOCK_VERIFIER: ~150 LOC
- MOCK_MATCHER: ~100 LOC
- MOCK_SERVER_POOL: ~100 LOC
- **Total**: ~1200 LOC

### Complexity Assessment

| Component | Complexity | Rationale |
|-----------|------------|-----------|
| SIMPLE_MOCK | Low | Facade, delegates to server |
| MOCK_SERVER | Medium | State management, expectations |
| MOCK_EXPECTATION | Medium | Fluent builder pattern |
| MOCK_VERIFIER | Low | Simple matching logic |
| MOCK_MATCHER | Low | Pattern matching |

## Performance Characteristics

### Memory Usage
- Expectations: O(n) where n = expectations
- Request history: O(m) where m = requests
- Reset clears all memory

### Matching Speed
- Linear scan of expectations
- O(n*m) for n expectations, m requests
- Acceptable for test volumes

### Scalability
- Designed for test volumes (< 1000 requests)
- Not for load testing
- Single-threaded operation

## Build Metrics

- Compile time: ~5 seconds
- Test suite: ~20 tests
- Dependencies: simple_mml

## Feature Count

| Category | Count |
|----------|-------|
| Expectation methods | 8 |
| Response configuration | 6 |
| Verification queries | 5 |
| Server control | 4 |

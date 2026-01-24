# 7S-03: SOLUTIONS - simple_mock


**Date**: 2026-01-23

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mock

## Alternative Solutions Evaluated

### 1. External Mock Server
- **Options**: WireMock, MockServer
- **Pros**: Full HTTP support, mature
- **Cons**: Java dependency, external process
- **Decision**: Rejected - prefer pure Eiffel

### 2. Record/Replay
- **Approach**: Record real traffic, replay in tests
- **Pros**: Realistic responses
- **Cons**: Maintenance burden, brittle tests
- **Decision**: Not implemented (future consideration)

### 3. In-Process Mocking Only
- **Approach**: No server, just in-memory matching
- **Pros**: Simple, fast
- **Cons**: Doesn't test actual HTTP layer
- **Decision**: Current implementation (works with simple_http)

### 4. Full HTTP Server (Chosen for future)
- **Approach**: Actual listening socket
- **Pros**: Tests real HTTP stack
- **Cons**: More complex, port management
- **Decision**: Architecture supports, not yet implemented

## Architecture Decisions

### Class Structure
- **SIMPLE_MOCK**: Facade for easy use
- **MOCK_SERVER**: Core server logic
- **MOCK_EXPECTATION**: Request/response pair
- **MOCK_REQUEST**: Captured request
- **MOCK_RESPONSE**: Configured response
- **MOCK_VERIFIER**: Verification logic
- **MOCK_MATCHER**: Request matching logic
- **MOCK_SERVER_POOL**: Connection reuse

### Model Integration
- Model queries return MML_SEQUENCE
- Enables DBC-style postconditions
- Immutable views of mutable state

## Technology Stack

- Pure Eiffel
- simple_mml for model types
- No network I/O (currently)

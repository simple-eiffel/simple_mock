# 7S-01: SCOPE - simple_mock

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mock

## Problem Statement

Testing HTTP clients and services requires simulating server responses without actual network calls. Traditional approaches involve complex mocking frameworks or running actual servers. Eiffel lacks a simple, contract-aware mock server library.

## Library Purpose

simple_mock provides an HTTP mock server for testing:

1. **Expectation-Based Mocking** - Define expected requests and responses
2. **Request Verification** - Verify that expected calls were made
3. **Fluent API** - Builder pattern for readable test setup
4. **DBC Integration** - Model queries for contract verification

## Target Users

- Developers testing HTTP client code
- Integration test writers
- Service-oriented architecture testing
- API client library developers

## Scope Boundaries

### In Scope
- HTTP mock server with configurable responses
- Request expectation matching (method, URL, headers, body)
- Response configuration (status, headers, body)
- Request history for verification
- Model queries for DBC (MML_SEQUENCE views)
- Connection pooling support

### Out of Scope
- Actual HTTP protocol implementation (placeholder)
- HTTPS/TLS support
- WebSocket mocking
- Real network I/O (would need simple_http)
- Load testing

## Success Metrics

- Easy test setup (< 10 lines per scenario)
- Full request history access
- MML model views for contracts
- Zero false positives in verification

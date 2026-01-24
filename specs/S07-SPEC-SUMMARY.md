# S07: SPECIFICATION SUMMARY - simple_mock

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mock

## Library Identity

- **Name**: simple_mock
- **Version**: 1.0
- **Category**: Testing / HTTP Mocking
- **Status**: Functional (HTTP pending)

## Purpose Statement

simple_mock provides an HTTP mock server framework for testing, with expectation-based mocking, fluent API, request verification, and MML model queries for Design by Contract integration.

## Key Capabilities

1. **Expectation Setup**
   - Fluent builder pattern
   - All HTTP methods (GET, POST, PUT, DELETE, etc.)
   - Header and body matching
   - Response configuration

2. **Request Verification**
   - was_requested queries
   - request_count tracking
   - unmatched_expectations list
   - Full request history

3. **DBC Integration**
   - model_expectations returns MML_SEQUENCE
   - model_received_requests returns MML_SEQUENCE
   - Postconditions verify state changes

4. **Server Lifecycle**
   - start/stop/reset
   - Port configuration
   - Connection pooling

## Architecture Summary

- **Pattern**: Facade with internal components
- **State**: Expectations + request history
- **Dependencies**: simple_mml

## Quality Attributes

| Attribute | Target |
|-----------|--------|
| Usability | < 10 lines per test scenario |
| Verification | No false positives |
| Isolation | Clean reset between tests |
| DBC | Full model query support |

## API Surface

### Primary API
- expect, expect_get, expect_post, expect_put, expect_delete
- start, stop, reset
- was_requested, request_count
- verify_all_matched, unmatched_expectations
- model_expectations, model_received_requests

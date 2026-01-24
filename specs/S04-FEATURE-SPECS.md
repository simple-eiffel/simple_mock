# S04: FEATURE SPECIFICATIONS - simple_mock

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mock

## SIMPLE_MOCK Features

### Access Queries
| Feature | Type | Description |
|---------|------|-------------|
| port | Query | Server port number |
| url | Query | Full URL (http://localhost:port) |
| server | Query | Underlying MOCK_SERVER |

### Status Queries
| Feature | Type | Description |
|---------|------|-------------|
| is_running | Query | Is server accepting requests? |
| was_requested | Query | Was URL called? |

### Measurement Queries
| Feature | Type | Description |
|---------|------|-------------|
| request_count | Query | Number of calls to URL |
| expectation_count | Query | Number of expectations |

### Server Control Commands
| Feature | Type | Description |
|---------|------|-------------|
| start | Command | Start accepting requests |
| stop | Command | Stop accepting requests |
| reset | Command | Clear expectations and history |

### Expectation Commands
| Feature | Type | Description |
|---------|------|-------------|
| expect | Command | Create expectation for method/URL |
| expect_get | Command | Shorthand for GET expectation |
| expect_post | Command | Shorthand for POST expectation |
| expect_put | Command | Shorthand for PUT expectation |
| expect_delete | Command | Shorthand for DELETE expectation |

### Verification Queries
| Feature | Type | Description |
|---------|------|-------------|
| received_requests | Query | All requests received |
| last_request | Query | Most recent request |
| verify_all_matched | Query | Were all expectations met? |
| unmatched_expectations | Query | Expectations not matched |

### Model Queries
| Feature | Type | Description |
|---------|------|-------------|
| model_expectations | Query | MML_SEQUENCE of expectations |
| model_received_requests | Query | MML_SEQUENCE of requests |

## MOCK_EXPECTATION Features

### Builder Methods (return Current)
| Feature | Type | Description |
|---------|------|-------------|
| with_header | Builder | Expect specific header |
| with_body | Builder | Expect specific body |
| with_body_containing | Builder | Expect body substring |
| respond_with_status | Builder | Set response status |
| respond_with_body | Builder | Set response body |
| respond_with_json | Builder | Set JSON response |
| respond_with_header | Builder | Add response header |
| times | Builder | Expect N times |

### Access Queries
| Feature | Type | Description |
|---------|------|-------------|
| method | Query | Expected HTTP method |
| url | Query | Expected URL |
| response | Query | Configured response |
| match_count | Query | Times matched |

### Matching
| Feature | Type | Description |
|---------|------|-------------|
| matches | Query | Does request match? |

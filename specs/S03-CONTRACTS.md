# S03: CONTRACTS - simple_mock

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mock

## SIMPLE_MOCK Contracts

### make_on_port (a_port: INTEGER)
```eiffel
require
  port_positive: a_port > 0
  port_valid: a_port <= 65535
ensure
  port_set: port = a_port
  not_running: not is_running
```

### start
```eiffel
require
  not_running: not is_running
ensure
  is_running: is_running
```

### stop
```eiffel
require
  is_running: is_running
ensure
  not_running: not is_running
```

### expect (a_method: STRING; a_url: STRING): MOCK_EXPECTATION
```eiffel
require
  method_not_empty: not a_method.is_empty
  url_not_empty: not a_url.is_empty
ensure
  expectation_added: expectation_count = old expectation_count + 1
  model_extended: model_expectations.count = old model_expectations.count + 1
  model_has_expectation: model_expectations.has (Result)
```

### expect_get (a_url: STRING): MOCK_EXPECTATION
```eiffel
require
  url_not_empty: not a_url.is_empty
ensure
  expectation_added: expectation_count = old expectation_count + 1
  is_get: Result.method.is_case_insensitive_equal ("GET")
```

## MOCK_SERVER Contracts

### make (a_port: INTEGER)
```eiffel
require
  port_positive: a_port > 0
  port_valid: a_port <= 65535
ensure
  port_set: port = a_port
  no_expectations: expectations.is_empty
  no_requests: received_requests.is_empty
  not_running: not is_running
  model_expectations_empty: model_expectations.is_empty
  model_requests_empty: model_received_requests.is_empty
```

### add_expectation (a_expectation: MOCK_EXPECTATION)
```eiffel
ensure
  one_more: expectation_count = old expectation_count + 1
  expectation_added: expectations.has (a_expectation)
  model_extended: model_expectations.count = old model_expectations.count + 1
  model_has_expectation: model_expectations.has (a_expectation)
```

### record_request (a_request: MOCK_REQUEST)
```eiffel
ensure
  one_more: request_count = old request_count + 1
  request_added: received_requests.has (a_request)
  model_extended: model_received_requests.count = old model_received_requests.count + 1
```

### clear_expectations
```eiffel
ensure
  empty: expectations.is_empty
  model_empty: model_expectations.is_empty
```

## Class Invariants

### SIMPLE_MOCK
```eiffel
invariant
  port_positive: port > 0
  port_valid: port <= 65535
  model_expectations_consistent: model_expectations.count = expectation_count
```

### MOCK_SERVER
```eiffel
invariant
  port_positive: port > 0
  port_valid: port <= 65535
  count_consistent: expectation_count = expectations.count
  request_count_consistent: request_count = received_requests.count
  model_expectations_consistent: model_expectations.count = expectations.count
  model_requests_consistent: model_received_requests.count = received_requests.count
```

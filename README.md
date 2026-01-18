<p align="center">
  <img src="docs/images/logo.png" alt="simple_mock logo" width="200">
</p>

<h1 align="center">simple_mock</h1>

<p align="center">
  <a href="https://simple-eiffel.github.io/simple_mock/">Documentation</a> •
  <a href="https://github.com/simple-eiffel/simple_mock">GitHub</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT">
  <img src="https://img.shields.io/badge/Eiffel-25.02-purple.svg" alt="Eiffel 25.02">
  <img src="https://img.shields.io/badge/DBC-Contracts-green.svg" alt="Design by Contract">
</p>

**HTTP mock server for testing** — Create expectations, record requests, verify calls. Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

✅ **Production Ready** — v1.0.0
- 7 classes, 108 features
- 50 tests passing (34 unit + 16 adversarial)
- Full Design by Contract coverage
- Design audit and hardening complete

## Overview

simple_mock is an HTTP mock server library for Eiffel that enables testing of HTTP client code without making real network requests. Define expectations for how your mock server should respond, start the server, run your tests, and verify the expected requests were made.

The library uses an expectation-based approach: you declare what requests you expect and what responses should be returned. The mock server records all incoming requests, allowing you to verify after the fact that your code made the correct HTTP calls with the right headers and bodies.

## Quick Start

```eiffel
local
    l_mock: SIMPLE_MOCK
do
    -- Create mock server on port 8080
    create l_mock.make

    -- Set up expectation
    l_mock.expect_get ("/api/users")
        .then_respond_json (200, "[{%"id%": 1, %"name%": %"Alice%"}]")

    -- Start server
    l_mock.start

    -- ... make HTTP calls to http://localhost:8080/api/users ...

    -- Verify request was made
    if l_mock.was_requested ("/api/users") then
        print ("API was called%N")
    end

    -- Stop server
    l_mock.stop
end
```

## API Reference

### SIMPLE_MOCK (Facade)

| Feature | Description |
|---------|-------------|
| `make` | Create on default port 8080 |
| `make_on_port (port)` | Create on specified port |
| `port` | Server port |
| `url` | Full URL (http://localhost:port) |
| `is_running` | Is server accepting requests? |
| `start` | Start the server |
| `stop` | Stop the server |
| `reset` | Clear expectations and history |
| `expect (method, url)` | Create expectation |
| `expect_get (url)` | Shorthand for GET |
| `expect_post (url)` | Shorthand for POST |
| `expect_put (url)` | Shorthand for PUT |
| `expect_delete (url)` | Shorthand for DELETE |
| `was_requested (url)` | Was URL requested? |
| `request_count (url)` | Number of requests to URL |
| `verify_all_matched` | All expectations matched? |

### MOCK_EXPECTATION (Chainable)

| Feature | Description |
|---------|-------------|
| `with_header (name, value)` | Require header |
| `with_body (body)` | Require exact body |
| `with_body_containing (text)` | Require body substring |
| `then_respond (status)` | Set status code |
| `then_respond_with_body (status, body)` | Set status and body |
| `then_respond_json (status, json)` | Set JSON response |
| `with_response_header (name, value)` | Add response header |
| `with_delay (ms)` | Add response delay |

### MOCK_MATCHER

| Feature | Description |
|---------|-------------|
| `make (method, url_pattern)` | Create matcher |
| `matches (request)` | Check if request matches |
| `matches_method (method)` | Check method match |
| `matches_url (url)` | Check URL match (with wildcards) |
| `set_body_contains (text)` | Require body substring |

### MOCK_RESPONSE

| Feature | Description |
|---------|-------------|
| `make (status)` | Create response with status code |
| `make_with_body (status, body)` | Create with body |
| `set_json_body (json)` | Set JSON body |
| `set_delay (ms)` | Set response delay |
| `add_header (name, value)` | Add response header |

### MOCK_REQUEST

| Feature | Description |
|---------|-------------|
| `make (method, url)` | Create request |
| `path` | URL path without query string |
| `query_string` | Query parameters |
| `is_get`, `is_post`, etc. | Method checks |
| `add_header (name, value)` | Add request header |
| `set_body (body)` | Set request body |

### MOCK_VERIFIER

| Feature | Description |
|---------|-------------|
| `make (server)` | Create verifier for server |
| `was_requested (url)` | Was URL requested? |
| `was_never_requested (url)` | Was URL never requested? |
| `request_count (url)` | Count of requests to URL |
| `unmatched_expectations` | Expectations not matched |
| `all_expectations_matched` | All expectations matched? |

## Features

- ✅ Expectation-based mocking
- ✅ Flexible URL matching with wildcards
- ✅ Header and body matching
- ✅ Request recording and verification
- ✅ Fluent chainable API
- ✅ Response delays for timeout testing
- ✅ Design by Contract throughout
- ✅ Void-safe
- ✅ SCOOP-compatible

## URL Pattern Matching

| Pattern | Matches |
|---------|---------|
| `/api/users` | Exact match |
| `/api/*` | `/api/users`, `/api/posts`, etc. |
| `/api/user?` | `/api/user1`, `/api/userA`, etc. |
| `/api/*/items` | `/api/123/items`, `/api/abc/items` |

## Installation

Add to your ECF file:

```xml
<library name="simple_mock" location="$SIMPLE_LIBS/simple_mock/simple_mock.ecf"/>
```

### Environment Setup

Set the `SIMPLE_LIBS` environment variable:
```bash
export SIMPLE_LIBS=/path/to/simple/libraries
```

## Dependencies

| Library | Purpose |
|---------|---------|
| EiffelBase | Standard library |

## License

MIT License - see [LICENSE](LICENSE) file.

---

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

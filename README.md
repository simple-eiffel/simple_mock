# simple_mock

[![Eiffel](https://img.shields.io/badge/Eiffel-25.02-blue.svg)](https://www.eiffel.org/)
[![Platform](https://img.shields.io/badge/platform-Windows-brightgreen.svg)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Simple Eiffel](https://img.shields.io/badge/Simple-Eiffel-purple.svg)](https://github.com/simple-eiffel)

HTTP mock server for testing - create expectations, record requests, verify calls.

## Features

- **Expectation-based mocking** - Define expected requests and responses
- **Flexible matching** - URL patterns with wildcards, header matching, body matching
- **Request recording** - Track all received requests
- **Verification** - Assert expected requests were made
- **Fluent API** - Chainable configuration for expectations
- **Design by Contract** - Full preconditions, postconditions, and invariants

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

## Standard API

### SIMPLE_MOCK (Facade)

| Feature | Type | Description |
|---------|------|-------------|
| `make` | Creation | Create on default port 8080 |
| `make_on_port (port)` | Creation | Create on specified port |
| `port` | Query | Server port |
| `url` | Query | Full URL (http://localhost:port) |
| `is_running` | Status | Is server accepting requests? |
| `start` | Command | Start the server |
| `stop` | Command | Stop the server |
| `reset` | Command | Clear expectations and history |
| `expect (method, url)` | Builder | Create expectation |
| `expect_get (url)` | Builder | Shorthand for GET |
| `expect_post (url)` | Builder | Shorthand for POST |
| `expect_put (url)` | Builder | Shorthand for PUT |
| `expect_delete (url)` | Builder | Shorthand for DELETE |
| `was_requested (url)` | Verify | Was URL requested? |
| `request_count (url)` | Verify | Number of requests to URL |
| `verify_all_matched` | Verify | All expectations matched? |

### MOCK_EXPECTATION (Chainable)

| Feature | Type | Description |
|---------|------|-------------|
| `with_header (name, value)` | Matcher | Require header |
| `with_body (body)` | Matcher | Require exact body |
| `with_body_containing (text)` | Matcher | Require body substring |
| `then_respond (status)` | Response | Set status code |
| `then_respond_with_body (status, body)` | Response | Set status and body |
| `then_respond_json (status, json)` | Response | Set JSON response |
| `with_response_header (name, value)` | Response | Add response header |
| `with_delay (ms)` | Response | Add response delay |

## URL Pattern Matching

The matcher supports glob-style wildcards:

| Pattern | Matches |
|---------|---------|
| `/api/users` | Exact match |
| `/api/*` | `/api/users`, `/api/posts`, etc. |
| `/api/user?` | `/api/user1`, `/api/userA`, etc. |
| `/api/*/items` | `/api/123/items`, `/api/abc/items` |

## Example: Testing HTTP Client

```eiffel
class
    MY_API_CLIENT_TEST

feature -- Test

    test_fetch_users
        local
            l_mock: SIMPLE_MOCK
            l_client: MY_API_CLIENT
        do
            -- Setup mock
            create l_mock.make_on_port (9999)
            l_mock.expect_get ("/api/users")
                .with_header ("Authorization", "Bearer token123")
                .then_respond_json (200, "[{%"id%": 1}]")
            l_mock.start

            -- Test client
            create l_client.make ("http://localhost:9999")
            l_client.set_token ("token123")
            l_client.fetch_users

            -- Verify
            assert ("users fetched", l_client.user_count = 1)
            assert ("api called", l_mock.was_requested ("/api/users"))
            assert ("all matched", l_mock.verify_all_matched)

            l_mock.stop
        end
end
```

## Architecture

```
SIMPLE_MOCK (Facade)
    |
    +-- MOCK_SERVER (HTTP server)
    |       |
    |       +-- MOCK_EXPECTATION[] (registered expectations)
    |       +-- MOCK_REQUEST[] (recorded requests)
    |
    +-- MOCK_VERIFIER (assertion helpers)

MOCK_EXPECTATION
    |
    +-- MOCK_MATCHER (URL/header/body matching)
    +-- MOCK_RESPONSE (status/body/headers)
```

## Dependencies

- EiffelBase (standard library)

## Installation

Add to your ECF:

```xml
<library name="simple_mock" location="$SIMPLE_EIFFEL/simple_mock/simple_mock.ecf"/>
```

## License

MIT License - see LICENSE file

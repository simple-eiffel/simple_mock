# simple_mock Specification (Step 01: Analyze Requirements)

## Date: 2026-01-18

## Problem Domain

HTTP mock server for testing Eiffel applications that make HTTP requests. Enables unit/integration testing without connecting to real servers.

---

## 1. DOMAIN MODEL

### Key Domain Concepts

| Concept | Definition | Relationships |
|---------|------------|---------------|
| Mock Server | HTTP server that returns predefined responses | Contains Expectations |
| Expectation | Request-response pair defining behavior | Has Matcher + Response |
| Matcher | Rules for matching incoming requests | Part of Expectation |
| Response | Predefined response to return | Part of Expectation |
| Request | Incoming HTTP request to match | Matched by Matcher |

### Domain Rules (ALWAYS hold)

1. Server must be started before accepting requests
2. Requests are matched against expectations in registration order
3. First matching expectation wins
4. Unmatched requests return 404

### Domain Rules (NEVER violated)

1. Port must be available when starting server
2. Cannot register expectations on stopped server
3. Cannot verify requests on stopped server

---

## 2. ENTITIES (Potential Classes)

### SIMPLE_MOCK
- **Domain meaning:** Facade for quick mock setup and verification
- **Domain rules:** High-level API, delegates to MOCK_SERVER

### MOCK_SERVER
- **Domain meaning:** HTTP server that serves mock responses
- **Domain rules:**
  - Must be on available port
  - Can only accept requests when running
  - Maintains list of expectations in order

### MOCK_EXPECTATION
- **Domain meaning:** Pair of request matcher and response to return
- **Domain rules:**
  - Must have at least one matcher criterion
  - Must have a response defined

### MOCK_MATCHER
- **Domain meaning:** Rules for deciding if request matches expectation
- **Domain rules:**
  - URL matching (exact or pattern)
  - Method matching (GET, POST, etc.)
  - Header matching (key-value pairs)
  - Body matching (exact, contains, JSON path)

### MOCK_RESPONSE
- **Domain meaning:** Predefined response to return when matched
- **Domain rules:**
  - Has status code (default 200)
  - Has headers (optional)
  - Has body (optional)
  - Has delay (optional, for timeout testing)

### MOCK_REQUEST
- **Domain meaning:** Record of received request for verification
- **Domain rules:**
  - Captures URL, method, headers, body
  - Captures timestamp

### MOCK_VERIFIER
- **Domain meaning:** Assertion helpers for test verification
- **Domain rules:**
  - Can assert request was made
  - Can assert request count
  - Can assert request details

---

## 3. ACTIONS (Potential Features)

### Server Actions

| Action | Domain Meaning | Valid When | Result |
|--------|----------------|------------|--------|
| start | Begin accepting requests | Not already running, port available | Server running on port |
| stop | Stop accepting requests | Currently running | Server stopped |
| reset | Clear all expectations and history | Any time | Clean slate |

### Expectation Actions

| Action | Domain Meaning | Valid When | Result |
|--------|----------------|------------|--------|
| expect | Register new expectation | Server exists | Expectation added |
| when_url | Match by URL pattern | Building expectation | Matcher configured |
| when_method | Match by HTTP method | Building expectation | Matcher configured |
| when_header | Match by header | Building expectation | Matcher configured |
| when_body | Match by body content | Building expectation | Matcher configured |
| then_respond | Define response | Matcher configured | Response configured |

### Response Actions

| Action | Domain Meaning | Valid When | Result |
|--------|----------------|------------|--------|
| with_status | Set status code | Building response | Status set |
| with_header | Add response header | Building response | Header added |
| with_body | Set response body | Building response | Body set |
| with_delay | Set response delay | Building response | Delay set |

### Verification Actions

| Action | Domain Meaning | Valid When | Result |
|--------|----------------|------------|--------|
| was_requested | Check if URL was hit | Server has history | Boolean |
| request_count | Count requests to URL | Server has history | Integer |
| verify_all | Assert all expectations met | Server has history | Boolean + report |

---

## 4. CONSTRAINTS (Contract Candidates)

### Preconditions ("cannot X")
- cannot register expectation if server not created
- cannot start if already running
- cannot stop if not running
- cannot match if no criteria set
- cannot respond if no status set

### Postconditions ("must X")
- start must result in is_running = True
- stop must result in is_running = False
- expect must add expectation to list
- reset must clear all expectations and history
- match must return matching expectation or Void

### Invariants ("always X")
- port always positive (1-65535)
- expectations always processed in registration order
- received_requests always contains all requests since start
- is_running consistent with actual server state

---

## 5. RELATIONSHIPS

| Relationship | Type | Domain Justification |
|--------------|------|---------------------|
| SIMPLE_MOCK → MOCK_SERVER | composition | Facade owns server |
| MOCK_SERVER → MOCK_EXPECTATION | composition | Server manages expectations |
| MOCK_EXPECTATION → MOCK_MATCHER | composition | Expectation has matcher |
| MOCK_EXPECTATION → MOCK_RESPONSE | composition | Expectation has response |
| MOCK_SERVER → MOCK_REQUEST | composition | Server records requests |
| SIMPLE_MOCK → MOCK_VERIFIER | uses | Facade uses verifier for assertions |

---

## 6. QUERIES vs COMMANDS

### Queries (return value, no state change)
- is_running: BOOLEAN
- port: INTEGER
- url: STRING (full server URL)
- expectation_count: INTEGER
- request_count (url): INTEGER
- was_requested (url): BOOLEAN
- received_requests: LIST [MOCK_REQUEST]
- last_request: MOCK_REQUEST

### Commands (modify state, no return value)
- start
- stop
- reset
- expect (returns expectation for chaining)

---

## 7. AMBIGUITIES (Flagged)

UNCLEAR: Should wildcards use glob pattern or regex?
- Decision: Use glob patterns (* and ?) for simplicity, like most mock frameworks

UNCLEAR: What happens if multiple expectations match?
- Decision: First registered expectation wins (order matters)

UNCLEAR: Should server run in separate thread?
- Decision: Yes, using SCOOP separate for concurrent operation

UNCLEAR: How to handle HTTPS?
- Decision: HTTP only for Phase 1, HTTPS in Phase 2

---

## Specification Quality Checks

- [x] Every domain concept has clear definition
- [x] Every domain rule captured
- [x] Every feature has domain meaning
- [x] Ambiguities explicitly flagged

---

## Dependencies

- simple_web (HTTP server foundation)
- simple_json (JSON body matching, JSON responses)

---

## Next Step
→ 02-DEFINE-CLASS-STRUCTURE.md

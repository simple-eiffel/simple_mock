# S02: CLASS CATALOG - simple_mock

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mock

## Core Classes

### SIMPLE_MOCK
- **Purpose**: Facade for HTTP mock server testing
- **Role**: Entry point for test setup and verification
- **Key Features**:
  - Server lifecycle (start/stop/reset)
  - Expectation creation (expect, expect_get, expect_post, etc.)
  - Verification queries
  - Model queries for DBC

### MOCK_SERVER
- **Purpose**: Core mock server implementation
- **Role**: Manages expectations and request history
- **Key Features**:
  - Expectation registration
  - Request recording
  - Matching logic
  - State management

### MOCK_EXPECTATION
- **Purpose**: Defines expected request and response
- **Role**: Builder for test setup
- **Key Features**:
  - Fluent interface (with_header, with_body, etc.)
  - Response configuration
  - Match tracking

### MOCK_REQUEST
- **Purpose**: Represents a captured HTTP request
- **Role**: Data class for request details
- **Key Features**:
  - Method, URL, headers, body
  - Timestamp
  - Comparison support

### MOCK_RESPONSE
- **Purpose**: Represents configured response
- **Role**: Data class for response details
- **Key Features**:
  - Status code
  - Headers
  - Body content

### MOCK_VERIFIER
- **Purpose**: Verification logic
- **Role**: Checks expectations against history
- **Key Features**:
  - was_requested queries
  - all_expectations_matched
  - unmatched_expectations list

### MOCK_MATCHER
- **Purpose**: Request matching logic
- **Role**: Determines if request matches expectation
- **Key Features**:
  - URL matching
  - Method matching
  - Header/body matching

### MOCK_SERVER_POOL
- **Purpose**: Server instance management
- **Role**: Reuse servers across tests
- **Key Features**:
  - Port allocation
  - Instance caching

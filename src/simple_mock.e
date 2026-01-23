note
	description: "Facade for HTTP mock server testing"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_MOCK

create
	make,
	make_on_port

feature {NONE} -- Initialization

	make
			-- Create mock server on default port.
		do
			make_on_port (Default_port)
		end

	make_on_port (a_port: INTEGER)
			-- Create mock server on `a_port'.
		require
			port_positive: a_port > 0
			port_valid: a_port <= 65535
		do
			create internal_server.make (a_port)
			create internal_verifier.make (internal_server)
		ensure
			port_set: port = a_port
			not_running: not is_running
		end

feature -- Access (Queries)

	port: INTEGER
			-- Port server is running on
		do
			Result := internal_server.port
		end

	url: STRING
			-- Full URL of mock server (http://localhost:port)
		do
			Result := "http://localhost:" + port.out
		end

	server: MOCK_SERVER
			-- Underlying mock server
		do
			Result := internal_server
		end

feature -- Status (Boolean Queries)

	is_running: BOOLEAN
			-- Is server accepting requests?
		do
			Result := internal_server.is_running
		end

	was_requested (a_url: STRING): BOOLEAN
			-- Was `a_url' requested?
		do
			Result := internal_verifier.was_requested (a_url)
		end

feature -- Measurement (Integer Queries)

	request_count (a_url: STRING): INTEGER
			-- Number of requests to `a_url'
		do
			Result := internal_verifier.request_count (a_url)
		end

	expectation_count: INTEGER
			-- Number of registered expectations
		do
			Result := internal_server.expectation_count
		end

feature -- Server Control (Commands)

	start
			-- Start the mock server.
		require
			not_running: not is_running
		do
			internal_server.start
		ensure
			is_running: is_running
		end

	stop
			-- Stop the mock server.
		require
			is_running: is_running
		do
			internal_server.stop
		ensure
			not_running: not is_running
		end

	reset
			-- Clear all expectations and request history.
		do
			internal_server.reset
		end

feature -- Expectation Building (Commands)

	expect (a_method: STRING; a_url: STRING): MOCK_EXPECTATION
			-- Create expectation for `a_method' on `a_url'.
		require
			method_not_empty: not a_method.is_empty
			url_not_empty: not a_url.is_empty
		do
			create Result.make (a_method, a_url)
			internal_server.add_expectation (Result)
		ensure
			expectation_added: expectation_count = old expectation_count + 1
			model_extended: model_expectations.count = old model_expectations.count + 1
			model_has_expectation: model_expectations.has (Result)
		end

	expect_get (a_url: STRING): MOCK_EXPECTATION
			-- Shorthand for GET expectation.
		require
			url_not_empty: not a_url.is_empty
		do
			Result := expect ("GET", a_url)
		ensure
			expectation_added: expectation_count = old expectation_count + 1
			is_get: Result.method.is_case_insensitive_equal ("GET")
		end

	expect_post (a_url: STRING): MOCK_EXPECTATION
			-- Shorthand for POST expectation.
		require
			url_not_empty: not a_url.is_empty
		do
			Result := expect ("POST", a_url)
		ensure
			expectation_added: expectation_count = old expectation_count + 1
			is_post: Result.method.is_case_insensitive_equal ("POST")
		end

	expect_put (a_url: STRING): MOCK_EXPECTATION
			-- Shorthand for PUT expectation.
		require
			url_not_empty: not a_url.is_empty
		do
			Result := expect ("PUT", a_url)
		ensure
			expectation_added: expectation_count = old expectation_count + 1
			is_put: Result.method.is_case_insensitive_equal ("PUT")
		end

	expect_delete (a_url: STRING): MOCK_EXPECTATION
			-- Shorthand for DELETE expectation.
		require
			url_not_empty: not a_url.is_empty
		do
			Result := expect ("DELETE", a_url)
		ensure
			expectation_added: expectation_count = old expectation_count + 1
			is_delete: Result.method.is_case_insensitive_equal ("DELETE")
		end

feature -- Verification (Queries)

	received_requests: ARRAYED_LIST [MOCK_REQUEST]
			-- All requests received since start
		do
			Result := internal_server.received_requests
		end

	last_request: detachable MOCK_REQUEST
			-- Most recent request received
		do
			if not internal_server.received_requests.is_empty then
				Result := internal_server.received_requests.last
			end
		end

	verify_all_matched: BOOLEAN
			-- Were all expectations matched at least once?
		do
			Result := internal_verifier.all_expectations_matched
		end

	unmatched_expectations: ARRAYED_LIST [MOCK_EXPECTATION]
			-- Expectations that were never matched
		do
			Result := internal_verifier.unmatched_expectations
		end

feature -- Model Queries (for Design by Contract)

	model_expectations: MML_SEQUENCE [MOCK_EXPECTATION]
			-- Model view of expectations as immutable sequence.
		do
			Result := internal_server.model_expectations
		ensure
			result_exists: Result /= Void
			same_count: Result.count = expectation_count
		end

	model_received_requests: MML_SEQUENCE [MOCK_REQUEST]
			-- Model view of received requests as immutable sequence.
		do
			Result := internal_server.model_received_requests
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Implementation

	internal_server: MOCK_SERVER
			-- The mock server

	internal_verifier: MOCK_VERIFIER
			-- The verifier

feature {NONE} -- Constants

	Default_port: INTEGER = 8080
			-- Default mock server port

invariant
	port_positive: port > 0
	port_valid: port <= 65535
	model_expectations_consistent: model_expectations.count = expectation_count

end

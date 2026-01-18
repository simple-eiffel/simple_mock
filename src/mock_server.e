note
	description: "HTTP mock server that serves predefined responses"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	MOCK_SERVER

create
	make

feature {NONE} -- Initialization

	make (a_port: INTEGER)
			-- Create server on `a_port'.
		require
			port_positive: a_port > 0
			port_valid: a_port <= 65535
		do
			port := a_port
			create expectations.make (Default_expectations_capacity)
			create received_requests.make (Default_requests_capacity)
			is_running := False
		ensure
			port_set: port = a_port
			no_expectations: expectations.is_empty
			no_requests: received_requests.is_empty
			not_running: not is_running
		end

feature -- Access (Queries)

	port: INTEGER
			-- Server port

	expectations: ARRAYED_LIST [MOCK_EXPECTATION]
			-- Registered expectations in order

	received_requests: ARRAYED_LIST [MOCK_REQUEST]
			-- All requests received

	last_error: detachable STRING
			-- Last error message if any

feature -- Status (Boolean Queries)

	is_running: BOOLEAN
			-- Is server accepting requests?

	has_error: BOOLEAN
			-- Did last operation fail?
		do
			Result := last_error /= Void
		end

feature -- Measurement (Integer Queries)

	expectation_count: INTEGER
			-- Number of expectations
		do
			Result := expectations.count
		end

	request_count: INTEGER
			-- Total requests received
		do
			Result := received_requests.count
		end

feature -- Server Control (Commands)

	start
			-- Start accepting requests.
		require
			not_running: not is_running
		do
			is_running := True
			last_error := Void
		ensure
			is_running: is_running
			no_error: not has_error
		end

	stop
			-- Stop accepting requests.
		require
			is_running: is_running
		do
			is_running := False
		ensure
			not_running: not is_running
		end

	reset
			-- Clear expectations and history.
		do
			clear_expectations
			clear_history
		end

feature -- Expectation Management (Commands)

	add_expectation (a_expectation: MOCK_EXPECTATION)
			-- Register `a_expectation'.
		require
			expectation_not_void: a_expectation /= Void
		do
			expectations.extend (a_expectation)
		ensure
			one_more: expectation_count = old expectation_count + 1
			expectation_added: expectations.has (a_expectation)
		end

	remove_expectation (a_expectation: MOCK_EXPECTATION)
			-- Unregister `a_expectation'.
		do
			expectations.prune (a_expectation)
		end

	clear_expectations
			-- Remove all expectations.
		do
			expectations.wipe_out
		end

feature -- Request Handling

	find_matching_expectation (a_request: MOCK_REQUEST): detachable MOCK_EXPECTATION
			-- Find first expectation matching `a_request'.
		do
			across expectations as l_exp loop
				if l_exp.matches (a_request) then
					Result := l_exp
				end
			end
		end

	record_request (a_request: MOCK_REQUEST)
			-- Add `a_request' to history.
		do
			received_requests.extend (a_request)
		end

	clear_history
			-- Clear request history.
		do
			received_requests.wipe_out
		ensure
			no_history: received_requests.is_empty
		end

feature {NONE} -- Constants

	Default_expectations_capacity: INTEGER = 10
			-- Default initial capacity for expectations list

	Default_requests_capacity: INTEGER = 50
			-- Default initial capacity for received requests list

invariant
	port_positive: port > 0
	port_valid: port <= 65535
	expectations_exist: expectations /= Void
	requests_exist: received_requests /= Void
	count_consistent: expectation_count = expectations.count
	request_count_consistent: request_count = received_requests.count

end

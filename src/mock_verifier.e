note
	description: "Assertion helpers for mock verification"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	MOCK_VERIFIER

create
	make

feature {NONE} -- Initialization

	make (a_server: MOCK_SERVER)
			-- Create verifier for `a_server'.
		do
			server := a_server
		end

feature -- Access (Queries)

	server: MOCK_SERVER
			-- Server to verify

	last_failure_message: detachable STRING
			-- Message from last failed assertion

feature -- Status (Boolean Queries)

	last_assertion_passed: BOOLEAN
			-- Did last assertion pass?

feature -- URL Assertions (Queries)

	was_requested (a_url: STRING): BOOLEAN
			-- Was `a_url' requested at least once?
		do
			Result := request_count (a_url) > 0
			last_assertion_passed := Result
			if not Result then
				last_failure_message := "URL not requested: " + a_url
			end
		end

	was_requested_times (a_url: STRING; a_count: INTEGER): BOOLEAN
			-- Was `a_url' requested exactly `a_count' times?
		local
			l_actual: INTEGER
		do
			l_actual := request_count (a_url)
			Result := l_actual = a_count
			last_assertion_passed := Result
			if not Result then
				last_failure_message := "Expected " + a_count.out + " requests to " + a_url + " but got " + l_actual.out
			end
		end

	was_requested_at_least (a_url: STRING; a_count: INTEGER): BOOLEAN
			-- Was `a_url' requested at least `a_count' times?
		local
			l_actual: INTEGER
		do
			l_actual := request_count (a_url)
			Result := l_actual >= a_count
			last_assertion_passed := Result
			if not Result then
				last_failure_message := "Expected at least " + a_count.out + " requests to " + a_url + " but got " + l_actual.out
			end
		end

	was_never_requested (a_url: STRING): BOOLEAN
			-- Was `a_url' never requested?
		do
			Result := request_count (a_url) = 0
			last_assertion_passed := Result
			if not Result then
				last_failure_message := "URL was requested but shouldn't have been: " + a_url
			end
		end

feature -- Method Assertions (Queries)

	was_get_requested (a_url: STRING): BOOLEAN
			-- Was GET request made to `a_url'?
		do
			Result := request_count_for_method ("GET", a_url) > 0
			last_assertion_passed := Result
		end

	was_post_requested (a_url: STRING): BOOLEAN
			-- Was POST request made to `a_url'?
		do
			Result := request_count_for_method ("POST", a_url) > 0
			last_assertion_passed := Result
		end

	was_put_requested (a_url: STRING): BOOLEAN
			-- Was PUT request made to `a_url'?
		do
			Result := request_count_for_method ("PUT", a_url) > 0
			last_assertion_passed := Result
		end

	was_delete_requested (a_url: STRING): BOOLEAN
			-- Was DELETE request made to `a_url'?
		do
			Result := request_count_for_method ("DELETE", a_url) > 0
			last_assertion_passed := Result
		end

feature -- Request Detail Assertions (Queries)

	was_requested_with_header (a_url: STRING; a_header: STRING; a_value: STRING): BOOLEAN
			-- Was `a_url' requested with header `a_header' = `a_value'?
		do
			across requests_to (a_url) as l_req loop
				if attached l_req.header_value (a_header) as l_val and then l_val.same_string (a_value) then
					Result := True
				end
			end
			last_assertion_passed := Result
		end

	was_requested_with_body (a_url: STRING; a_body: STRING): BOOLEAN
			-- Was `a_url' requested with exact `a_body'?
		do
			across requests_to (a_url) as l_req loop
				if l_req.body.same_string (a_body) then
					Result := True
				end
			end
			last_assertion_passed := Result
		end

	was_requested_with_body_containing (a_url: STRING; a_substring: STRING): BOOLEAN
			-- Was `a_url' requested with body containing `a_substring'?
		do
			across requests_to (a_url) as l_req loop
				if l_req.body.has_substring (a_substring) then
					Result := True
				end
			end
			last_assertion_passed := Result
		end

feature -- Expectation Assertions (Queries)

	all_expectations_matched: BOOLEAN
			-- Were all registered expectations matched?
		do
			Result := unmatched_expectations.is_empty
			last_assertion_passed := Result
		end

	unmatched_expectations: ARRAYED_LIST [MOCK_EXPECTATION]
			-- Expectations that were never matched
		do
			create Result.make (5)
			across server.expectations as l_exp loop
				if not l_exp.was_matched then
					Result.extend (l_exp)
				end
			end
		end

feature -- Request Counting (Queries)

	request_count (a_url: STRING): INTEGER
			-- Number of requests to `a_url'.
		do
			across server.received_requests as l_req loop
				if l_req.url.same_string (a_url) or l_req.url.has_substring (a_url) then
					Result := Result + 1
				end
			end
		end

	request_count_for_method (a_method: STRING; a_url: STRING): INTEGER
			-- Number of `a_method' requests to `a_url'.
		do
			across server.received_requests as l_req loop
				if l_req.method.is_case_insensitive_equal (a_method) and then
				   (l_req.url.same_string (a_url) or l_req.url.has_substring (a_url)) then
					Result := Result + 1
				end
			end
		end

	total_request_count: INTEGER
			-- Total number of requests received.
		do
			Result := server.request_count
		end

feature -- Request Access (Queries)

	requests_to (a_url: STRING): ARRAYED_LIST [MOCK_REQUEST]
			-- All requests made to `a_url'.
		do
			create Result.make (10)
			across server.received_requests as l_req loop
				if l_req.url.same_string (a_url) or l_req.url.has_substring (a_url) then
					Result.extend (l_req)
				end
			end
		end

	last_request_to (a_url: STRING): detachable MOCK_REQUEST
			-- Most recent request to `a_url'.
		local
			l_requests: ARRAYED_LIST [MOCK_REQUEST]
		do
			l_requests := requests_to (a_url)
			if not l_requests.is_empty then
				Result := l_requests.last
			end
		end

end

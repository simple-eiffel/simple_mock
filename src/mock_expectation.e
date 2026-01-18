note
	description: "Expected request pattern and response to return"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	MOCK_EXPECTATION

create
	make

feature {NONE} -- Initialization

	make (a_method: STRING; a_url: STRING)
			-- Create expectation for `a_method' on `a_url'.
		require
			method_not_empty: not a_method.is_empty
			url_not_empty: not a_url.is_empty
		do
			create matcher.make (a_method, a_url)
			create response.make (Http_status_ok)
			match_count := 0
		ensure
			method_set: method.same_string (a_method)
			url_set: url_pattern.same_string (a_url)
			not_matched: not was_matched
		end

feature -- Access (Queries)

	method: STRING
			-- HTTP method to match
		do
			Result := matcher.method
		end

	url_pattern: STRING
			-- URL pattern to match (supports * and ? wildcards)
		do
			Result := matcher.url_pattern
		end

	matcher: MOCK_MATCHER
			-- Full matching rules

	response: MOCK_RESPONSE
			-- Response to return when matched

	match_count: INTEGER
			-- Number of times this expectation was matched

feature -- Status (Boolean Queries)

	was_matched: BOOLEAN
			-- Was this expectation matched at least once?
		do
			Result := match_count > 0
		end

	matches (a_request: MOCK_REQUEST): BOOLEAN
			-- Does `a_request' match this expectation?
		do
			Result := matcher.matches (a_request)
		end

feature -- Matcher Configuration (Commands returning self for chaining)

	with_header (a_name: STRING; a_value: STRING): MOCK_EXPECTATION
			-- Also match header `a_name' with `a_value'.
		do
			matcher.add_header_requirement (a_name, a_value)
			Result := Current
		end

	with_body (a_body: STRING): MOCK_EXPECTATION
			-- Also match exact body content.
		do
			matcher.set_body_exact (a_body)
			Result := Current
		end

	with_body_containing (a_substring: STRING): MOCK_EXPECTATION
			-- Also match body containing `a_substring'.
		do
			matcher.set_body_contains (a_substring)
			Result := Current
		end

	with_json_path (a_path: STRING; a_value: STRING): MOCK_EXPECTATION
			-- Also match JSON body where `a_path' equals `a_value'.
		do
			matcher.add_json_path_requirement (a_path, a_value)
			Result := Current
		end

feature -- Response Configuration (Commands returning self for chaining)

	then_respond (a_status: INTEGER): MOCK_EXPECTATION
			-- Set response status code.
		do
			response.set_status (a_status)
			Result := Current
		end

	then_respond_with_body (a_status: INTEGER; a_body: STRING): MOCK_EXPECTATION
			-- Set response status and body.
		do
			response.set_status (a_status)
			response.set_body (a_body)
			Result := Current
		end

	then_respond_json (a_status: INTEGER; a_json: STRING): MOCK_EXPECTATION
			-- Set response status and JSON body.
		do
			response.set_status (a_status)
			response.set_json_body (a_json)
			Result := Current
		end

	with_response_header (a_name: STRING; a_value: STRING): MOCK_EXPECTATION
			-- Add response header.
		do
			response.add_header (a_name, a_value)
			Result := Current
		end

	with_delay (a_milliseconds: INTEGER): MOCK_EXPECTATION
			-- Add response delay for timeout testing.
		do
			response.set_delay (a_milliseconds)
			Result := Current
		end

feature -- Tracking (Commands)

	record_match
			-- Record that this expectation was matched.
		do
			match_count := match_count + 1
		ensure
			count_increased: match_count = old match_count + 1
			was_matched: was_matched
		end

feature {NONE} -- Constants

	Http_status_ok: INTEGER = 200
			-- HTTP 200 OK default response status

invariant
	matcher_exists: matcher /= Void
	response_exists: response /= Void
	count_non_negative: match_count >= 0
	was_matched_consistent: was_matched = (match_count > 0)

end

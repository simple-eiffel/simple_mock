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
			model_count_zero: model_match_count = 0
			model_headers_empty: model_response_headers.is_empty
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
		require
			name_not_empty: not a_name.is_empty
			value_not_empty: not a_value.is_empty
		do
			matcher.add_header_requirement (a_name, a_value)
			Result := Current
		ensure
			same_object: Result = Current
			header_required: model_required_headers.domain [a_name]
		end

	with_body (a_body: STRING): MOCK_EXPECTATION
			-- Also match exact body content.
		require
			body_not_empty: not a_body.is_empty
		do
			matcher.set_body_exact (a_body)
			Result := Current
		ensure
			same_object: Result = Current
			body_set: matcher.body_exact /= Void
		end

	with_body_containing (a_substring: STRING): MOCK_EXPECTATION
			-- Also match body containing `a_substring'.
		require
			substring_not_empty: not a_substring.is_empty
		do
			matcher.set_body_contains (a_substring)
			Result := Current
		ensure
			same_object: Result = Current
			contains_set: matcher.body_contains /= Void
		end

	with_json_path (a_path: STRING; a_value: STRING): MOCK_EXPECTATION
			-- Also match JSON body where `a_path' equals `a_value'.
		require
			path_not_empty: not a_path.is_empty
		do
			matcher.add_json_path_requirement (a_path, a_value)
			Result := Current
		ensure
			same_object: Result = Current
			path_added: matcher.json_path_requirements.count > 0
		end

feature -- Response Configuration (Commands returning self for chaining)

	then_respond_with_object (a_status: INTEGER; a_object: ANY): MOCK_EXPECTATION
			-- Set response status and body from object fields as JSON.
			-- Uses simple_reflection to convert object to JSON.
		require
			valid_status: a_status >= 100 and a_status <= 599
		local
			l_json: STRING
		do
			l_json := object_to_json (a_object)
			response.set_status (a_status)
			response.set_json_body (l_json)
			Result := Current
		ensure
			same_object: Result = Current
			status_set: response.status_code = a_status
			response_has_json: model_response_headers.domain ["Content-Type"]
		end

	then_respond (a_status: INTEGER): MOCK_EXPECTATION
			-- Set response status code.
		require
			valid_status: a_status >= 100 and a_status <= 599
		do
			response.set_status (a_status)
			Result := Current
		ensure
			same_object: Result = Current
			status_set: response.status_code = a_status
		end

	then_respond_with_body (a_status: INTEGER; a_body: STRING): MOCK_EXPECTATION
			-- Set response status and body.
		require
			valid_status: a_status >= 100 and a_status <= 599
		do
			response.set_status (a_status)
			response.set_body (a_body)
			Result := Current
		ensure
			same_object: Result = Current
			status_set: response.status_code = a_status
			body_set: response.body.same_string (a_body)
		end

	then_respond_json (a_status: INTEGER; a_json: STRING): MOCK_EXPECTATION
			-- Set response status and JSON body.
		require
			valid_status: a_status >= 100 and a_status <= 599
		do
			response.set_status (a_status)
			response.set_json_body (a_json)
			Result := Current
		ensure
			same_object: Result = Current
			status_set: response.status_code = a_status
			body_set: response.body.same_string (a_json)
			is_json: model_response_headers.domain ["Content-Type"]
		end

	with_response_header (a_name: STRING; a_value: STRING): MOCK_EXPECTATION
			-- Add response header.
		require
			name_not_empty: not a_name.is_empty
			value_not_empty: not a_value.is_empty
		do
			response.add_header (a_name, a_value)
			Result := Current
		ensure
			same_object: Result = Current
			header_added: model_response_headers.domain [a_name]
			header_value: attached model_response_headers [a_name] as v implies v.same_string (a_value)
		end

	with_delay (a_milliseconds: INTEGER): MOCK_EXPECTATION
			-- Add response delay for timeout testing.
		require
			non_negative: a_milliseconds >= 0
		do
			response.set_delay (a_milliseconds)
			Result := Current
		ensure
			same_object: Result = Current
			delay_set: response.delay_ms = a_milliseconds
		end

feature -- Tracking (Commands)

	record_match
			-- Record that this expectation was matched.
		do
			match_count := match_count + 1
		ensure
			count_increased: match_count = old match_count + 1
			was_matched: was_matched
			model_consistent: model_match_count = match_count
		end

feature -- Model Queries (for Design by Contract)

	model_match_count: INTEGER
			-- Model view of match count.
		do
			Result := match_count
		ensure
			non_negative: Result >= 0
			consistent: Result = match_count
		end

	model_response_headers: MML_MAP [STRING, STRING]
			-- Model view of response headers as immutable map.
		local
			l_keys: ARRAY [STRING]
			i: INTEGER
		do
			create Result
			l_keys := response.headers.current_keys
			from i := l_keys.lower until i > l_keys.upper loop
				if attached response.headers.item (l_keys [i]) as l_val then
					Result := Result.updated (l_keys [i], l_val)
				end
				i := i + 1
			end
		ensure
			result_exists: Result /= Void
		end

	model_required_headers: MML_MAP [STRING, STRING]
			-- Model view of required headers as immutable map.
		local
			l_keys: ARRAY [STRING]
			i: INTEGER
		do
			create Result
			l_keys := matcher.required_headers.current_keys
			from i := l_keys.lower until i > l_keys.upper loop
				if attached matcher.required_headers.item (l_keys [i]) as l_val then
					Result := Result.updated (l_keys [i], l_val)
				end
				i := i + 1
			end
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Implementation (simple_reflection integration)

	object_to_json (a_object: ANY): STRING
			-- Convert object fields to JSON string.
		require
			object_exists: a_object /= Void
		local
			l_reflected: SIMPLE_REFLECTED_OBJECT
			l_field: SIMPLE_FIELD_INFO
			l_value: detachable ANY
			i: INTEGER
			l_first: BOOLEAN
		do
			create Result.make (100)
			Result.append ("{")
			l_first := True
			create l_reflected.make (a_object)
			from
				i := 1
			until
				i > l_reflected.type_info.fields.count
			loop
				l_field := l_reflected.type_info.fields [i]
				l_value := l_field.value (a_object)
				if not l_first then
					Result.append (", ")
				end
				l_first := False
				Result.append ("%"")
				Result.append (l_field.name.to_string_8)
				Result.append ("%": ")
				Result.append (value_to_json (l_value))
				i := i + 1
			end
			Result.append ("}")
		ensure
			result_exists: Result /= Void
			is_json_object: Result.starts_with ("{") and Result.ends_with ("}")
		end

	value_to_json (a_value: detachable ANY): STRING
			-- Convert value to JSON string representation.
		do
			if a_value = Void then
				Result := "null"
			elseif attached {BOOLEAN} a_value as l_bool then
				Result := if l_bool then "true" else "false" end
			elseif attached {INTEGER} a_value as l_int then
				Result := l_int.out
			elseif attached {INTEGER_64} a_value as l_int64 then
				Result := l_int64.out
			elseif attached {REAL_64} a_value as l_real then
				Result := l_real.out
			elseif attached {READABLE_STRING_GENERAL} a_value as l_str then
				Result := "%"" + escape_json_string (l_str.to_string_8) + "%""
			else
				Result := "%"" + escape_json_string (a_value.out) + "%""
			end
		ensure
			result_exists: Result /= Void
		end

	escape_json_string (a_str: STRING): STRING
			-- Escape special characters for JSON.
		local
			i: INTEGER
			c: CHARACTER
		do
			create Result.make (a_str.count)
			from i := 1 until i > a_str.count loop
				c := a_str.item (i)
				inspect c
				when '"' then Result.append ("\%"")
				when '\' then Result.append ("\\")
				when '%N' then Result.append ("\n")
				when '%R' then Result.append ("\r")
				when '%T' then Result.append ("\t")
				else Result.append_character (c)
				end
				i := i + 1
			end
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Constants

	Http_status_ok: INTEGER = 200
			-- HTTP 200 OK default response status

invariant
	count_non_negative: match_count >= 0
	was_matched_consistent: was_matched = (match_count > 0)
	model_count_consistent: model_match_count = match_count

end

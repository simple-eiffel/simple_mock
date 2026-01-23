note
	description: "Predefined HTTP response to return when matched"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	MOCK_RESPONSE

create
	make,
	make_with_body

feature {NONE} -- Initialization

	make (a_status: INTEGER)
			-- Create response with `a_status' code.
		require
			valid_status: a_status >= Min_http_status and a_status <= Max_http_status
		do
			status_code := a_status
			create headers.make (Default_headers_capacity)
			body := ""
			delay_ms := 0
		ensure
			status_set: status_code = a_status
			no_body: body.is_empty
			no_delay: delay_ms = 0
		end

	make_with_body (a_status: INTEGER; a_body: STRING)
			-- Create response with `a_status' and `a_body'.
		require
			valid_status: a_status >= Min_http_status and a_status <= Max_http_status
		do
			make (a_status)
			body := a_body
		ensure
			status_set: status_code = a_status
			body_set: body.same_string (a_body)
		end

feature -- Access (Queries)

	status_code: INTEGER
			-- HTTP status code (200, 404, 500, etc.)

	headers: HASH_TABLE [STRING, STRING]
			-- Response headers (name -> value)

	body: STRING
			-- Response body content

	delay_ms: INTEGER
			-- Delay before sending response (milliseconds)

	content_type: STRING
			-- Content-Type header value
		do
			if attached headers.item ("Content-Type") as l_ct then
				Result := l_ct
			else
				Result := "text/plain"
			end
		end

feature -- Status (Boolean Queries)

	has_body: BOOLEAN
			-- Is body content set?
		do
			Result := not body.is_empty
		end

	has_delay: BOOLEAN
			-- Is delay configured?
		do
			Result := delay_ms > 0
		end

	is_json: BOOLEAN
			-- Is Content-Type application/json?
		do
			Result := content_type.has_substring ("application/json")
		end

feature -- Configuration (Commands)

	set_status (a_status: INTEGER)
			-- Set status code.
		require
			valid_status: a_status >= Min_http_status and a_status <= Max_http_status
		do
			status_code := a_status
		ensure
			status_set: status_code = a_status
		end

	set_body (a_body: STRING)
			-- Set response body.
		do
			body := a_body
		ensure
			body_set: body.same_string (a_body)
		end

	set_json_body (a_json: STRING)
			-- Set JSON body and Content-Type.
		do
			body := a_json
			add_header ("Content-Type", "application/json")
		ensure
			body_set: body.same_string (a_json)
			content_type_set: model_headers.domain ["Content-Type"]
		end

	add_header (a_name: STRING; a_value: STRING)
			-- Add response header.
		require
			name_not_empty: not a_name.is_empty
			value_not_empty: not a_value.is_empty
		do
			headers.force (a_value, a_name)
		ensure
			header_added: headers.has (a_name)
			model_has_header: model_headers.domain [a_name]
		end

	set_content_type (a_type: STRING)
			-- Set Content-Type header.
		require
			type_not_empty: not a_type.is_empty
		do
			add_header ("Content-Type", a_type)
		ensure
			type_set: model_headers.domain ["Content-Type"]
		end

	set_delay (a_milliseconds: INTEGER)
			-- Set response delay.
		require
			non_negative: a_milliseconds >= 0
		do
			delay_ms := a_milliseconds
		ensure
			delay_set: delay_ms = a_milliseconds
		end

feature -- Model Queries (for Design by Contract)

	model_headers: MML_MAP [STRING, STRING]
			-- Model view of headers as immutable map.
		local
			l_keys: ARRAY [STRING]
			i: INTEGER
		do
			create Result
			l_keys := headers.current_keys
			from i := l_keys.lower until i > l_keys.upper loop
				if attached headers.item (l_keys [i]) as l_val then
					Result := Result.updated (l_keys [i], l_val)
				end
				i := i + 1
			end
		ensure
			result_exists: Result /= Void
		end

feature -- Constants

	Min_http_status: INTEGER = 100
			-- Minimum valid HTTP status code

	Max_http_status: INTEGER = 599
			-- Maximum valid HTTP status code

feature {NONE} -- Implementation Constants

	Default_headers_capacity: INTEGER = 5
			-- Default initial capacity for headers table

invariant
	valid_status_code: status_code >= Min_http_status and status_code <= Max_http_status
	non_negative_delay: delay_ms >= 0

end

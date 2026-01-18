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
		do
			status_code := a_status
			create headers.make (5)
			body := ""
			delay_ms := 0
		end

	make_with_body (a_status: INTEGER; a_body: STRING)
			-- Create response with `a_status' and `a_body'.
		do
			make (a_status)
			body := a_body
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
		do
			status_code := a_status
		end

	set_body (a_body: STRING)
			-- Set response body.
		do
			body := a_body
		end

	set_json_body (a_json: STRING)
			-- Set JSON body and Content-Type.
		do
			body := a_json
			add_header ("Content-Type", "application/json")
		end

	add_header (a_name: STRING; a_value: STRING)
			-- Add response header.
		do
			headers.force (a_value, a_name)
		end

	set_content_type (a_type: STRING)
			-- Set Content-Type header.
		do
			add_header ("Content-Type", a_type)
		end

	set_delay (a_milliseconds: INTEGER)
			-- Set response delay.
		do
			delay_ms := a_milliseconds
		end

end

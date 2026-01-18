note
	description: "Record of received HTTP request for verification"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	MOCK_REQUEST

create
	make

feature {NONE} -- Initialization

	make (a_method: STRING; a_url: STRING)
			-- Create request record for `a_method' on `a_url'.
		do
			method := a_method
			url := a_url
			create headers.make (10)
			body := ""
			create timestamp.make_now
		end

feature -- Access (Queries)

	method: STRING
			-- HTTP method (GET, POST, etc.)

	url: STRING
			-- Request URL

	path: STRING
			-- URL path portion only
		local
			l_pos: INTEGER
		do
			l_pos := url.index_of ('?', 1)
			if l_pos > 0 then
				Result := url.substring (1, l_pos - 1)
			else
				Result := url
			end
		end

	query_string: detachable STRING
			-- Query string portion (after ?)
		local
			l_pos: INTEGER
		do
			l_pos := url.index_of ('?', 1)
			if l_pos > 0 and l_pos < url.count then
				Result := url.substring (l_pos + 1, url.count)
			end
		end

	headers: HASH_TABLE [STRING, STRING]
			-- Request headers (name -> value)

	body: STRING
			-- Request body content

	timestamp: DATE_TIME
			-- When request was received

feature -- Status (Boolean Queries)

	has_body: BOOLEAN
			-- Does request have body content?
		do
			Result := not body.is_empty
		end

	has_header (a_name: STRING): BOOLEAN
			-- Is header `a_name' present?
		do
			Result := headers.has (a_name)
		end

	is_get: BOOLEAN
			-- Is this a GET request?
		do
			Result := method.is_case_insensitive_equal ("GET")
		end

	is_post: BOOLEAN
			-- Is this a POST request?
		do
			Result := method.is_case_insensitive_equal ("POST")
		end

	is_put: BOOLEAN
			-- Is this a PUT request?
		do
			Result := method.is_case_insensitive_equal ("PUT")
		end

	is_delete: BOOLEAN
			-- Is this a DELETE request?
		do
			Result := method.is_case_insensitive_equal ("DELETE")
		end

feature -- Header Access (Queries)

	header_value (a_name: STRING): detachable STRING
			-- Value of header `a_name', or Void if not present.
		do
			Result := headers.item (a_name)
		end

feature -- Configuration (Commands)

	set_body (a_body: STRING)
			-- Set request body.
		do
			body := a_body
		end

	add_header (a_name: STRING; a_value: STRING)
			-- Add request header.
		do
			headers.force (a_value, a_name)
		end

	set_query_string (a_query: STRING)
			-- Set query string.
		local
			l_pos: INTEGER
		do
			l_pos := url.index_of ('?', 1)
			if l_pos > 0 then
				url := url.substring (1, l_pos - 1) + "?" + a_query
			else
				url := url + "?" + a_query
			end
		end

end

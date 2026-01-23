note
	description: "Rules for matching incoming HTTP requests"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	MOCK_MATCHER

create
	make

feature {NONE} -- Initialization

	make (a_method: STRING; a_url_pattern: STRING)
			-- Create matcher for `a_method' and `a_url_pattern'.
		require
			method_not_empty: not a_method.is_empty
			url_pattern_not_empty: not a_url_pattern.is_empty
			valid_http_method: is_valid_http_method (a_method)
		do
			method := a_method.as_upper
			url_pattern := a_url_pattern
			create required_headers.make (Default_headers_capacity)
			create json_path_requirements.make (Default_json_paths_capacity)
		ensure
			method_set: method.is_case_insensitive_equal (a_method)
			url_pattern_set: url_pattern.same_string (a_url_pattern)
		end

feature -- Access (Queries)

	method: STRING
			-- HTTP method to match (GET, POST, etc.)

	url_pattern: STRING
			-- URL pattern (supports * and ? wildcards)

	required_headers: HASH_TABLE [STRING, STRING]
			-- Headers that must be present (name -> value)

	body_exact: detachable STRING
			-- Exact body content to match (if set)

	body_contains: detachable STRING
			-- Substring body must contain (if set)

	json_path_requirements: ARRAYED_LIST [TUPLE [path: STRING; value: STRING]]
			-- JSON path requirements (if set)

feature -- Status (Boolean Queries)

	has_header_requirements: BOOLEAN
			-- Are there header matching requirements?
		do
			Result := not required_headers.is_empty
		end

	has_body_requirements: BOOLEAN
			-- Are there body matching requirements?
		do
			Result := body_exact /= Void or body_contains /= Void or not json_path_requirements.is_empty
		end

	matches (a_request: MOCK_REQUEST): BOOLEAN
			-- Does `a_request' match all criteria?
		do
			Result := matches_method (a_request.method) and then
			          matches_url (a_request.url) and then
			          matches_headers (a_request.headers) and then
			          matches_body (a_request.body)
		end

	matches_url (a_url: STRING): BOOLEAN
			-- Does `a_url' match url_pattern?
		do
			if url_pattern.has ('*') or url_pattern.has ('?') then
				Result := glob_matches (url_pattern, a_url)
			else
				Result := a_url.same_string (url_pattern) or else a_url.has_substring (url_pattern)
			end
		end

	matches_method (a_method: STRING): BOOLEAN
			-- Does `a_method' match required method?
		do
			Result := method.is_case_insensitive_equal (a_method)
		end

	matches_headers (a_headers: HASH_TABLE [STRING, STRING]): BOOLEAN
			-- Do `a_headers' satisfy requirements?
		local
			l_keys: ARRAY [STRING]
			l_key: STRING
			l_i: INTEGER
		do
			Result := True
			l_keys := required_headers.current_keys
			from l_i := l_keys.lower until l_i > l_keys.upper or not Result loop
				l_key := l_keys [l_i]
				if attached a_headers.item (l_key) as l_actual then
					if attached required_headers.item (l_key) as l_expected then
						if not l_actual.same_string (l_expected) then
							Result := False
						end
					end
				else
					Result := False
				end
				l_i := l_i + 1
			end
		end

	matches_body (a_body: STRING): BOOLEAN
			-- Does `a_body' satisfy requirements?
		do
			Result := True
			if attached body_exact as l_exact then
				Result := a_body.same_string (l_exact)
			end
			if Result and attached body_contains as l_contains then
				Result := a_body.has_substring (l_contains)
			end
			-- JSON path matching would require simple_json integration
		end

feature -- Configuration (Commands)

	add_header_requirement (a_name: STRING; a_value: STRING)
			-- Require header `a_name' with `a_value'.
		require
			name_not_empty: not a_name.is_empty
			value_not_empty: not a_value.is_empty
		do
			required_headers.force (a_value, a_name)
		ensure
			header_added: required_headers.has (a_name)
			header_value: attached required_headers.item (a_name) as v implies v.same_string (a_value)
			model_has_header: model_required_headers.domain [a_name]
		end

	set_body_exact (a_body: STRING)
			-- Require exact body match.
		require
			body_not_empty: not a_body.is_empty
		do
			body_exact := a_body
		ensure
			body_set: body_exact /= Void
			body_value: attached body_exact as b implies b.same_string (a_body)
		end

	set_body_contains (a_substring: STRING)
			-- Require body contains `a_substring'.
		require
			substring_not_empty: not a_substring.is_empty
		do
			body_contains := a_substring
		ensure
			contains_set: body_contains /= Void
			contains_value: attached body_contains as c implies c.same_string (a_substring)
		end

	add_json_path_requirement (a_path: STRING; a_value: STRING)
			-- Require JSON at `a_path' equals `a_value'.
		require
			path_not_empty: not a_path.is_empty
		do
			json_path_requirements.extend ([a_path, a_value])
		ensure
			one_more: json_path_requirements.count = old json_path_requirements.count + 1
		end

feature -- Validation

	is_valid_http_method (a_method: STRING): BOOLEAN
			-- Is `a_method' a valid HTTP method?
		do
			Result := a_method.is_case_insensitive_equal ("GET") or else
			          a_method.is_case_insensitive_equal ("POST") or else
			          a_method.is_case_insensitive_equal ("PUT") or else
			          a_method.is_case_insensitive_equal ("DELETE") or else
			          a_method.is_case_insensitive_equal ("PATCH") or else
			          a_method.is_case_insensitive_equal ("HEAD") or else
			          a_method.is_case_insensitive_equal ("OPTIONS")
		end

feature -- Model Queries (for Design by Contract)

	model_required_headers: MML_MAP [STRING, STRING]
			-- Model view of required headers as immutable map.
		local
			l_keys: ARRAY [STRING]
			i: INTEGER
		do
			create Result
			l_keys := required_headers.current_keys
			from i := l_keys.lower until i > l_keys.upper loop
				if attached required_headers.item (l_keys [i]) as l_val then
					Result := Result.updated (l_keys [i], l_val)
				end
				i := i + 1
			end
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Implementation

	glob_matches (a_pattern: STRING; a_text: STRING): BOOLEAN
			-- Does `a_text' match glob `a_pattern'?
		local
			l_pi, l_ti: INTEGER
			l_star_pi, l_star_ti: INTEGER
		do
			from
				l_pi := 1
				l_ti := 1
				l_star_pi := 0
				l_star_ti := 0
			until
				l_ti > a_text.count
			loop
				if l_pi <= a_pattern.count and then (a_pattern.item (l_pi) = '?' or a_pattern.item (l_pi) = a_text.item (l_ti)) then
					l_pi := l_pi + 1
					l_ti := l_ti + 1
				elseif l_pi <= a_pattern.count and then a_pattern.item (l_pi) = '*' then
					l_star_pi := l_pi
					l_star_ti := l_ti
					l_pi := l_pi + 1
				elseif l_star_pi > 0 then
					l_pi := l_star_pi + 1
					l_star_ti := l_star_ti + 1
					l_ti := l_star_ti
				else
					Result := False
					l_ti := a_text.count + 1 -- exit loop
				end
			end
			if l_ti > a_text.count then
				from until l_pi > a_pattern.count or else a_pattern.item (l_pi) /= '*' loop
					l_pi := l_pi + 1
				end
				Result := l_pi > a_pattern.count
			end
		end

feature {NONE} -- Constants

	Default_headers_capacity: INTEGER = 5
			-- Default initial capacity for required headers table

	Default_json_paths_capacity: INTEGER = 3
			-- Default initial capacity for JSON path requirements

invariant
	method_not_empty: not method.is_empty
	url_pattern_not_empty: not url_pattern.is_empty
	method_uppercase: method.same_string (method.as_upper)

end

note
	description: "Cached pool of mock servers by port (simple_factory integration)"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	MOCK_SERVER_POOL

create
	make

feature {NONE} -- Initialization

	make
			-- Create mock server pool.
		do
			-- Lazy initialization via once
		ensure
			cache_exists: internal_cache /= Void
		end

feature -- Access

	server_for_port (a_port: INTEGER): MOCK_SERVER
			-- Get or create mock server on `a_port'.
		require
			port_valid: a_port > 0 and a_port <= 65535
		do
			Result := internal_cache.item (a_port)
		ensure
			result_exists: Result /= Void
			correct_port: Result.port = a_port
			is_cached: is_cached (a_port)
		end

	default_server: MOCK_SERVER
			-- Get or create server on default port (8080).
		do
			Result := server_for_port (8080)
		ensure
			result_exists: Result /= Void
		end

feature -- Status

	is_cached (a_port: INTEGER): BOOLEAN
			-- Is server for `a_port' currently cached?
		do
			Result := internal_cache.is_cached (a_port)
		end

	cached_count: INTEGER
			-- Number of cached servers.
		do
			Result := internal_cache.cached_count
		end

feature -- Removal

	invalidate (a_port: INTEGER)
			-- Remove server for `a_port' from cache.
		do
			internal_cache.invalidate (a_port)
		ensure
			not_cached: not is_cached (a_port)
		end

	invalidate_all
			-- Remove all cached servers.
		do
			internal_cache.invalidate_all
		ensure
			empty: cached_count = 0
		end

feature {NONE} -- Implementation

	internal_cache: SIMPLE_CACHED_VALUE [MOCK_SERVER, INTEGER]
			-- Cache of servers by port.
		once ("OBJECT")
			create Result.make (agent create_server_for_port)
		end

	create_server_for_port (a_port: INTEGER): MOCK_SERVER
			-- Factory method to create new server.
		require
			port_valid: a_port > 0 and a_port <= 65535
		do
			create Result.make (a_port)
		ensure
			result_exists: Result /= Void
			correct_port: Result.port = a_port
		end

invariant
	cache_exists: internal_cache /= Void

end

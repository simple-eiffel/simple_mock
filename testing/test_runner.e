note
	description: "Test runner for simple_mock"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_RUNNER

create
	make

feature {NONE} -- Initialization

	make
			-- Run tests.
		do
			print ("simple_mock test runner%N")
			print ("=============================%N")
			run_all_tests
			print ("%N=============================%N")
			print ("Results: " + passed.out + " passed, " + failed.out + " failed%N")
			if failed = 0 then
				print ("ALL TESTS PASSED%N")
			end

			-- Run adversarial tests
			run_adversarial_tests
		end

feature -- Test Execution

	run_all_tests
			-- Run all test suites.
		do
			run_simple_mock_tests
			run_mock_server_tests
			run_mock_expectation_tests
			run_mock_matcher_tests
			run_mock_response_tests
			run_mock_request_tests
			run_mock_verifier_tests
		end

feature -- SIMPLE_MOCK Tests

	run_simple_mock_tests
		local
			l_mock: SIMPLE_MOCK
			l_exp: MOCK_EXPECTATION
		do
			print ("%N-- SIMPLE_MOCK Tests --%N")

			-- Test make
			create l_mock.make
			if l_mock.port = 8080 and not l_mock.is_running then
				report_pass ("test_simple_mock_make")
			else
				report_fail ("test_simple_mock_make")
			end

			-- Test make_on_port
			create l_mock.make_on_port (3000)
			if l_mock.port = 3000 then
				report_pass ("test_simple_mock_make_on_port")
			else
				report_fail ("test_simple_mock_make_on_port")
			end

			-- Test url
			create l_mock.make_on_port (8888)
			if l_mock.url.same_string ("http://localhost:8888") then
				report_pass ("test_simple_mock_url")
			else
				report_fail ("test_simple_mock_url")
			end

			-- Test start/stop
			create l_mock.make
			l_mock.start
			if l_mock.is_running then
				l_mock.stop
				if not l_mock.is_running then
					report_pass ("test_simple_mock_start_stop")
				else
					report_fail ("test_simple_mock_start_stop - stop failed")
				end
			else
				report_fail ("test_simple_mock_start_stop - start failed")
			end

			-- Test expect
			create l_mock.make
			l_exp := l_mock.expect_get ("/api/users")
			if l_mock.expectation_count = 1 then
				report_pass ("test_simple_mock_expect")
			else
				report_fail ("test_simple_mock_expect")
			end

			-- Test reset
			create l_mock.make
			l_exp := l_mock.expect_get ("/test")
			l_exp := l_mock.expect_post ("/data")
			l_mock.reset
			if l_mock.expectation_count = 0 then
				report_pass ("test_simple_mock_reset")
			else
				report_fail ("test_simple_mock_reset")
			end
		end

feature -- MOCK_SERVER Tests

	run_mock_server_tests
		local
			l_server: MOCK_SERVER
			l_exp: MOCK_EXPECTATION
			l_req: MOCK_REQUEST
		do
			print ("%N-- MOCK_SERVER Tests --%N")

			-- Test make
			create l_server.make (9000)
			if l_server.port = 9000 and not l_server.is_running then
				report_pass ("test_mock_server_make")
			else
				report_fail ("test_mock_server_make")
			end

			-- Test start
			create l_server.make (9000)
			l_server.start
			if l_server.is_running then
				report_pass ("test_mock_server_start")
			else
				report_fail ("test_mock_server_start")
			end

			-- Test add_expectation
			create l_server.make (9000)
			create l_exp.make ("GET", "/test")
			l_server.add_expectation (l_exp)
			if l_server.expectation_count = 1 then
				report_pass ("test_mock_server_add_expectation")
			else
				report_fail ("test_mock_server_add_expectation")
			end

			-- Test record_request
			create l_server.make (9000)
			create l_req.make ("GET", "/api/test")
			l_server.record_request (l_req)
			if l_server.request_count = 1 then
				report_pass ("test_mock_server_record_request")
			else
				report_fail ("test_mock_server_record_request")
			end

			-- Test find_matching_expectation
			create l_server.make (9000)
			create l_exp.make ("GET", "/api/users")
			l_server.add_expectation (l_exp)
			create l_req.make ("GET", "/api/users")
			if attached l_server.find_matching_expectation (l_req) as l_found then
				report_pass ("test_mock_server_find_matching")
			else
				report_fail ("test_mock_server_find_matching")
			end
		end

feature -- MOCK_EXPECTATION Tests

	run_mock_expectation_tests
		local
			l_exp: MOCK_EXPECTATION
			l_req: MOCK_REQUEST
		do
			print ("%N-- MOCK_EXPECTATION Tests --%N")

			-- Test make
			create l_exp.make ("POST", "/api/data")
			if l_exp.method.same_string ("POST") and l_exp.url_pattern.same_string ("/api/data") then
				report_pass ("test_mock_expectation_make")
			else
				report_fail ("test_mock_expectation_make")
			end

			-- Test matches
			create l_exp.make ("GET", "/users")
			create l_req.make ("GET", "/users")
			if l_exp.matches (l_req) then
				report_pass ("test_mock_expectation_matches")
			else
				report_fail ("test_mock_expectation_matches")
			end

			-- Test not matches (different method)
			create l_exp.make ("GET", "/users")
			create l_req.make ("POST", "/users")
			if not l_exp.matches (l_req) then
				report_pass ("test_mock_expectation_not_matches_method")
			else
				report_fail ("test_mock_expectation_not_matches_method")
			end

			-- Test record_match
			create l_exp.make ("GET", "/test")
			if not l_exp.was_matched then
				l_exp.record_match
				if l_exp.was_matched and l_exp.match_count = 1 then
					report_pass ("test_mock_expectation_record_match")
				else
					report_fail ("test_mock_expectation_record_match - count wrong")
				end
			else
				report_fail ("test_mock_expectation_record_match - initially matched")
			end

			-- Test chaining
			create l_exp.make ("POST", "/api/data")
			l_exp := l_exp.then_respond (201).with_response_header ("Location", "/api/data/123")
			if l_exp.response.status_code = 201 then
				report_pass ("test_mock_expectation_chaining")
			else
				report_fail ("test_mock_expectation_chaining")
			end
		end

feature -- MOCK_MATCHER Tests

	run_mock_matcher_tests
		local
			l_matcher: MOCK_MATCHER
			l_req: MOCK_REQUEST
		do
			print ("%N-- MOCK_MATCHER Tests --%N")

			-- Test exact URL match
			create l_matcher.make ("GET", "/api/users")
			create l_req.make ("GET", "/api/users")
			if l_matcher.matches (l_req) then
				report_pass ("test_mock_matcher_exact_url")
			else
				report_fail ("test_mock_matcher_exact_url")
			end

			-- Test wildcard URL match
			create l_matcher.make ("GET", "/api/*")
			create l_req.make ("GET", "/api/users")
			if l_matcher.matches_url ("/api/users") then
				report_pass ("test_mock_matcher_wildcard_url")
			else
				report_fail ("test_mock_matcher_wildcard_url")
			end

			-- Test method matching
			create l_matcher.make ("POST", "/test")
			if l_matcher.matches_method ("POST") and l_matcher.matches_method ("post") then
				report_pass ("test_mock_matcher_method")
			else
				report_fail ("test_mock_matcher_method")
			end

			-- Test body contains
			create l_matcher.make ("POST", "/api")
			l_matcher.set_body_contains ("hello")
			if l_matcher.matches_body ("say hello world") and not l_matcher.matches_body ("goodbye") then
				report_pass ("test_mock_matcher_body_contains")
			else
				report_fail ("test_mock_matcher_body_contains")
			end
		end

feature -- MOCK_RESPONSE Tests

	run_mock_response_tests
		local
			l_resp: MOCK_RESPONSE
		do
			print ("%N-- MOCK_RESPONSE Tests --%N")

			-- Test make
			create l_resp.make (200)
			if l_resp.status_code = 200 and not l_resp.has_body then
				report_pass ("test_mock_response_make")
			else
				report_fail ("test_mock_response_make")
			end

			-- Test make_with_body
			create l_resp.make_with_body (201, "{%"id%": 1}")
			if l_resp.status_code = 201 and l_resp.has_body then
				report_pass ("test_mock_response_make_with_body")
			else
				report_fail ("test_mock_response_make_with_body")
			end

			-- Test set_json_body
			create l_resp.make (200)
			l_resp.set_json_body ("{%"test%": true}")
			if l_resp.is_json and l_resp.has_body then
				report_pass ("test_mock_response_set_json_body")
			else
				report_fail ("test_mock_response_set_json_body")
			end

			-- Test delay
			create l_resp.make (200)
			l_resp.set_delay (1000)
			if l_resp.has_delay and l_resp.delay_ms = 1000 then
				report_pass ("test_mock_response_delay")
			else
				report_fail ("test_mock_response_delay")
			end
		end

feature -- MOCK_REQUEST Tests

	run_mock_request_tests
		local
			l_req: MOCK_REQUEST
		do
			print ("%N-- MOCK_REQUEST Tests --%N")

			-- Test make
			create l_req.make ("GET", "/api/users")
			if l_req.method.same_string ("GET") and l_req.url.same_string ("/api/users") then
				report_pass ("test_mock_request_make")
			else
				report_fail ("test_mock_request_make")
			end

			-- Test path extraction
			create l_req.make ("GET", "/api/users?page=1")
			if l_req.path.same_string ("/api/users") then
				report_pass ("test_mock_request_path")
			else
				report_fail ("test_mock_request_path")
			end

			-- Test query_string extraction
			create l_req.make ("GET", "/api/users?page=1&limit=10")
			if attached l_req.query_string as l_qs and then l_qs.same_string ("page=1&limit=10") then
				report_pass ("test_mock_request_query_string")
			else
				report_fail ("test_mock_request_query_string")
			end

			-- Test is_* methods
			create l_req.make ("GET", "/test")
			if l_req.is_get and not l_req.is_post then
				report_pass ("test_mock_request_is_get")
			else
				report_fail ("test_mock_request_is_get")
			end

			-- Test headers
			create l_req.make ("POST", "/api")
			l_req.add_header ("Content-Type", "application/json")
			if l_req.has_header ("Content-Type") and attached l_req.header_value ("Content-Type") as l_ct and then l_ct.same_string ("application/json") then
				report_pass ("test_mock_request_headers")
			else
				report_fail ("test_mock_request_headers")
			end
		end

feature -- MOCK_VERIFIER Tests

	run_mock_verifier_tests
		local
			l_server: MOCK_SERVER
			l_verifier: MOCK_VERIFIER
			l_req: MOCK_REQUEST
			l_exp: MOCK_EXPECTATION
		do
			print ("%N-- MOCK_VERIFIER Tests --%N")

			-- Test was_requested
			create l_server.make (9000)
			create l_verifier.make (l_server)
			create l_req.make ("GET", "/api/users")
			l_server.record_request (l_req)
			if l_verifier.was_requested ("/api/users") then
				report_pass ("test_mock_verifier_was_requested")
			else
				report_fail ("test_mock_verifier_was_requested")
			end

			-- Test was_never_requested
			create l_server.make (9000)
			create l_verifier.make (l_server)
			if l_verifier.was_never_requested ("/nonexistent") then
				report_pass ("test_mock_verifier_was_never_requested")
			else
				report_fail ("test_mock_verifier_was_never_requested")
			end

			-- Test request_count
			create l_server.make (9000)
			create l_verifier.make (l_server)
			create l_req.make ("GET", "/api/test")
			l_server.record_request (l_req)
			l_server.record_request (l_req)
			if l_verifier.request_count ("/api/test") = 2 then
				report_pass ("test_mock_verifier_request_count")
			else
				report_fail ("test_mock_verifier_request_count")
			end

			-- Test unmatched_expectations
			create l_server.make (9000)
			create l_verifier.make (l_server)
			create l_exp.make ("GET", "/expected")
			l_server.add_expectation (l_exp)
			if l_verifier.unmatched_expectations.count = 1 then
				report_pass ("test_mock_verifier_unmatched")
			else
				report_fail ("test_mock_verifier_unmatched")
			end

			-- Test all_expectations_matched (after matching)
			create l_server.make (9000)
			create l_verifier.make (l_server)
			create l_exp.make ("GET", "/test")
			l_exp.record_match
			l_server.add_expectation (l_exp)
			if l_verifier.all_expectations_matched then
				report_pass ("test_mock_verifier_all_matched")
			else
				report_fail ("test_mock_verifier_all_matched")
			end
		end

feature -- Adversarial Tests

	run_adversarial_tests
			-- Run adversarial contract tests.
		local
			l_adv: ADVERSARIAL_TESTS
		do
			create l_adv.make
			l_adv.run_all
		end

feature {NONE} -- Reporting

	passed, failed: INTEGER

	report_pass (a_name: STRING)
		do
			print ("  PASS: " + a_name + "%N")
			passed := passed + 1
		end

	report_fail (a_name: STRING)
		do
			print ("  FAIL: " + a_name + "%N")
			failed := failed + 1
		end

end

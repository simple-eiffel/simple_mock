note
	description: "Adversarial tests for simple_mock"
	date: "2026-01-18"

class
	ADVERSARIAL_TESTS

create
	make

feature {NONE} -- Initialization

	make
		do
			passed := 0
			failed := 0
			risk := 0
		end

feature -- Counters

	passed, failed, risk: INTEGER

feature -- Empty Input Tests

	test_empty_url_expect_get
			-- Empty URL should be rejected.
		local
			l_mock: SIMPLE_MOCK
			l_exp: MOCK_EXPECTATION
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_mock.make
				l_exp := l_mock.expect_get ("")  -- Should fail precondition
				failed := failed + 1
				print ("  FAIL: test_empty_url_expect_get - No exception%N")
			end
		rescue
			passed := passed + 1
			print ("  PASS: test_empty_url_expect_get - Contract caught empty URL%N")
			l_retried := True
			retry
		end

	test_empty_method_matcher
			-- Empty method should be rejected by MOCK_MATCHER.
		local
			l_matcher: MOCK_MATCHER
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_matcher.make ("", "/api/test")  -- Should fail precondition
				failed := failed + 1
				print ("  FAIL: test_empty_method_matcher - No exception%N")
			end
		rescue
			passed := passed + 1
			print ("  PASS: test_empty_method_matcher - Contract caught empty method%N")
			l_retried := True
			retry
		end

	test_empty_url_matcher
			-- Empty URL should be rejected by MOCK_MATCHER.
		local
			l_matcher: MOCK_MATCHER
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_matcher.make ("GET", "")  -- Should fail precondition
				failed := failed + 1
				print ("  FAIL: test_empty_url_matcher - No exception%N")
			end
		rescue
			passed := passed + 1
			print ("  PASS: test_empty_url_matcher - Contract caught empty URL%N")
			l_retried := True
			retry
		end

	test_empty_method_request
			-- Empty method should be rejected by MOCK_REQUEST.
		local
			l_req: MOCK_REQUEST
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_req.make ("", "/api/test")  -- Should fail precondition
				failed := failed + 1
				print ("  FAIL: test_empty_method_request - No exception%N")
			end
		rescue
			passed := passed + 1
			print ("  PASS: test_empty_method_request - Contract caught empty method%N")
			l_retried := True
			retry
		end

feature -- Invalid HTTP Method Tests

	test_invalid_http_method
			-- Invalid HTTP method should be rejected.
		local
			l_matcher: MOCK_MATCHER
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_matcher.make ("BANANA", "/api/test")  -- Should fail precondition
				failed := failed + 1
				print ("  FAIL: test_invalid_http_method - No exception%N")
			end
		rescue
			passed := passed + 1
			print ("  PASS: test_invalid_http_method - Contract caught invalid method%N")
			l_retried := True
			retry
		end

	test_invalid_http_method_numbers
			-- Numeric method should be rejected.
		local
			l_matcher: MOCK_MATCHER
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_matcher.make ("12345", "/api/test")  -- Should fail precondition
				failed := failed + 1
				print ("  FAIL: test_invalid_http_method_numbers - No exception%N")
			end
		rescue
			passed := passed + 1
			print ("  PASS: test_invalid_http_method_numbers - Contract caught invalid method%N")
			l_retried := True
			retry
		end

feature -- Invalid Status Code Tests

	test_status_code_negative
			-- Negative status code should be rejected.
		local
			l_resp: MOCK_RESPONSE
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_resp.make (-1)  -- Should fail precondition
				failed := failed + 1
				print ("  FAIL: test_status_code_negative - No exception%N")
			end
		rescue
			passed := passed + 1
			print ("  PASS: test_status_code_negative - Contract caught negative status%N")
			l_retried := True
			retry
		end

	test_status_code_zero
			-- Zero status code should be rejected.
		local
			l_resp: MOCK_RESPONSE
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_resp.make (0)  -- Should fail precondition
				failed := failed + 1
				print ("  FAIL: test_status_code_zero - No exception%N")
			end
		rescue
			passed := passed + 1
			print ("  PASS: test_status_code_zero - Contract caught zero status%N")
			l_retried := True
			retry
		end

	test_status_code_too_low
			-- Status code 99 should be rejected.
		local
			l_resp: MOCK_RESPONSE
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_resp.make (99)  -- Should fail precondition
				failed := failed + 1
				print ("  FAIL: test_status_code_too_low - No exception%N")
			end
		rescue
			passed := passed + 1
			print ("  PASS: test_status_code_too_low - Contract caught status < 100%N")
			l_retried := True
			retry
		end

	test_status_code_too_high
			-- Status code 600 should be rejected.
		local
			l_resp: MOCK_RESPONSE
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_resp.make (600)  -- Should fail precondition
				failed := failed + 1
				print ("  FAIL: test_status_code_too_high - No exception%N")
			end
		rescue
			passed := passed + 1
			print ("  PASS: test_status_code_too_high - Contract caught status > 599%N")
			l_retried := True
			retry
		end

feature -- Boundary Value Tests

	test_status_code_min_valid
			-- Status code 100 should be accepted.
		local
			l_resp: MOCK_RESPONSE
		do
			create l_resp.make (100)
			if l_resp.status_code = 100 then
				passed := passed + 1
				print ("  PASS: test_status_code_min_valid - Status 100 accepted%N")
			else
				failed := failed + 1
				print ("  FAIL: test_status_code_min_valid - Status not set%N")
			end
		end

	test_status_code_max_valid
			-- Status code 599 should be accepted.
		local
			l_resp: MOCK_RESPONSE
		do
			create l_resp.make (599)
			if l_resp.status_code = 599 then
				passed := passed + 1
				print ("  PASS: test_status_code_max_valid - Status 599 accepted%N")
			else
				failed := failed + 1
				print ("  FAIL: test_status_code_max_valid - Status not set%N")
			end
		end

	test_valid_http_methods
			-- All valid HTTP methods should be accepted.
		local
			l_matcher: MOCK_MATCHER
		do
			create l_matcher.make ("GET", "/test")
			create l_matcher.make ("POST", "/test")
			create l_matcher.make ("PUT", "/test")
			create l_matcher.make ("DELETE", "/test")
			create l_matcher.make ("PATCH", "/test")
			create l_matcher.make ("HEAD", "/test")
			create l_matcher.make ("OPTIONS", "/test")
			passed := passed + 1
			print ("  PASS: test_valid_http_methods - All 7 methods accepted%N")
		end

	test_http_method_case_insensitive
			-- HTTP methods should be case-insensitive.
		local
			l_matcher: MOCK_MATCHER
		do
			create l_matcher.make ("get", "/test")
			create l_matcher.make ("Get", "/test")
			create l_matcher.make ("gEt", "/test")
			passed := passed + 1
			print ("  PASS: test_http_method_case_insensitive - Case variations accepted%N")
		end

feature -- Delay Tests

	test_negative_delay
			-- Negative delay should be rejected.
		local
			l_resp: MOCK_RESPONSE
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_resp.make (200)
				l_resp.set_delay (-1)  -- Should fail precondition
				failed := failed + 1
				print ("  FAIL: test_negative_delay - No exception%N")
			end
		rescue
			passed := passed + 1
			print ("  PASS: test_negative_delay - Contract caught negative delay%N")
			l_retried := True
			retry
		end

	test_zero_delay_valid
			-- Zero delay should be accepted.
		local
			l_resp: MOCK_RESPONSE
		do
			create l_resp.make (200)
			l_resp.set_delay (0)
			if l_resp.delay_ms = 0 then
				passed := passed + 1
				print ("  PASS: test_zero_delay_valid - Zero delay accepted%N")
			else
				failed := failed + 1
				print ("  FAIL: test_zero_delay_valid - Delay not set%N")
			end
		end

feature -- Run All

	run_all
		do
			print ("%N=== Adversarial Tests ===%N")

			print ("%N-- Empty Input Tests --%N")
			test_empty_url_expect_get
			test_empty_method_matcher
			test_empty_url_matcher
			test_empty_method_request

			print ("%N-- Invalid HTTP Method Tests --%N")
			test_invalid_http_method
			test_invalid_http_method_numbers

			print ("%N-- Invalid Status Code Tests --%N")
			test_status_code_negative
			test_status_code_zero
			test_status_code_too_low
			test_status_code_too_high

			print ("%N-- Boundary Value Tests --%N")
			test_status_code_min_valid
			test_status_code_max_valid
			test_valid_http_methods
			test_http_method_case_insensitive

			print ("%N-- Delay Tests --%N")
			test_negative_delay
			test_zero_delay_valid

			print ("%N=== Summary: " + passed.out + " pass, " + failed.out + " fail ===%N")
		end

end

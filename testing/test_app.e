note
	description: "Test application for SIMPLE_MOCK"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run the tests.
		do
			print ("Running SIMPLE_MOCK tests...%N%N")
			passed := 0
			failed := 0

			run_lib_tests
			run_full_suite

			print ("%N========================%N")
			print ("Results: " + passed.out + " passed, " + failed.out + " failed%N")

			if failed > 0 then
				print ("TESTS FAILED%N")
			else
				print ("ALL TESTS PASSED%N")
			end
		end

feature {NONE} -- Test Runners

	run_lib_tests
		do
			create lib_tests
			run_test (agent lib_tests.test_creation, "test_creation")
		end

	run_full_suite
			-- TEST_RUNNER's suites and the adversarial tests (port-coordination #17: the gate's
			-- root ran one test; these 50-odd ran in no gate).
		local
			l_runner: TEST_RUNNER
		do
			create l_runner.make
			passed := passed + l_runner.passed
			failed := failed + l_runner.failed
			if l_runner.risk > 0 then
				print ("Adversarial risks (invalid input accepted): " + l_runner.risk.out + "%N")
			end
		end

feature {NONE} -- Implementation

	lib_tests: LIB_TESTS
	passed, failed: INTEGER

	run_test (a_test: PROCEDURE; a_name: STRING)
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				a_test.call (Void)
				print ("  PASS: " + a_name + "%N")
				passed := passed + 1
			end
		rescue
			print ("  FAIL: " + a_name + "%N")
			failed := failed + 1
			l_retried := True
			retry
		end

end

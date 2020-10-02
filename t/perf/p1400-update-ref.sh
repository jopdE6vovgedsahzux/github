#!/bin/sh

test_description="Tests performance of update-ref"

. ./perf-lib.sh

test_perf_fresh_repo

test_expect_success "setup" '
	test_commit PRE &&
	test_commit POST &&
	printf "create refs/heads/%d PRE\n" $(test_seq 1000) >create &&
	printf "update refs/heads/%d POST PRE\n" $(test_seq 1000) >update &&
	printf "delete refs/heads/%d POST\n" $(test_seq 1000) >delete
'

test_perf "update-ref" '
	for i in $(test_seq 1000)
	do
		git update-ref refs/heads/branch PRE &&
		git update-ref refs/heads/branch POST PRE &&
		git update-ref -d refs/heads/branch
	done
'

test_perf "update-ref --stdin" '
	git update-ref --stdin <create &&
	git update-ref --stdin <update &&
	git update-ref --stdin <delete
'

test_done

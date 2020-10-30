.PHONY:  help
.DEFAULT_GOAL := help

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-30s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

test: ## rust test
	cargo test --color=always --package mipha --lib spy::tests::test_tracer --no-fail-fast -- --exact -Z unstable-options --format=json --show-output --nocapture

start: ## start
	systemfd --no-pid -s http::13333 -- cargo watch -x run

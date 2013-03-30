.PHONY: build

build:
	@find src -name '*.coffee' | xargs node_modules/coffee-script/bin/coffee -c -o lib

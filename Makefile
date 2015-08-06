#
# Environment.
#

NODE ?= node

#
# Binaries.
#

BIN = ./node_modules/.bin

ESLINT := $(BIN)/eslint
COFFEE := $(BIN)/coffee

default: build

test: | node_modules
	@$(MOCHA) --recursive --compilers js:mocha-traceur

lint: | node_modules
	@$(ESLINT) src/

clean-deps:
	@rm -rf node_modules

install-deps:
	@npm install

clean:
	@rm -rf dist

build: | node_modules
	@$(COFFEE) -c src/code_sequence.coffee
	@mv src/*.js dist/

.PHONY: test

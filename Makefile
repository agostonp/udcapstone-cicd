## The Makefile includes instructions on environment setup and lint tests

setup:
	# Create python virtualenv & source it
	#python3 -m venv ~/.udproj-kubernetes
	#source ~/.udproj-kubernetes/bin/activate

install:
	# Install dependencies
	echo "No dependencies to install."

test:
	# Additional, optional, tests could go here

lint:
	# This is linter for Dockerfiles
	# hadolint Dockerfile
	docker run --rm -i hadolint/hadolint < Dockerfile
	# Lint the html files using tidy
	tidy -q -e www/*.html

all: install lint test

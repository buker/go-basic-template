
default: help
# generate help info from comments: thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help build
help: ## help information about make commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
# Docker compose commands
docker-build:
	echo "Building docker image"
	ocker build -t PROJECTNAME -f docker/Dockerfile .

# ==============================================================================
# Tools commands

lint:
	echo "Starting linters"
	golangci-lint run ./...

fmt:
	echo "Run fmt"
	gofmt -s -w .


# ==============================================================================
# Main

run:
	go run main.go

build:
	go build -o bin/ main.go

test:
	go test -cover ./...


# ==============================================================================
# Modules support

deps-reset:
	git checkout -- go.mod
	go mod tidy
	go mod vendor

tidy:
	go mod tidy
	go mod vendor

deps-upgrade:
	# go get $(go list -f '{{if not (or .Main .Indirect)}}{{.Path}}{{end}}' -m all)
	go get -u -t -d -v ./...
	go mod tidy
	go mod vendor

deps-cleancache:
	go clean -modcache


# ==============================================================================
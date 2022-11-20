default: help

.PHONY: help 
help: ## print this help message: see https://stackoverflow.com/a/64996042
	@echo 'Usage:'
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-22s\033[0m %s\n", $$1, $$2}'

.PHONY: confirm 
confirm: ## confirm y or N
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

# ==================================================================================== #
# BUILD
# ==================================================================================== #

.PHONY: build
build: ## build the main app to ./bin/main
	go build -o ./bin/main ./cmd/api

.PHONY: buildprod
buildprod: ## build main app for prod (no debug with gdb available)
	go build -ldflags='-s' -o ./bin/main ./cmd/api

.PHONY: build/api
build/api: ## build the cmd/api application
	@echo 'Building cmd/api...'
	go build -ldflags='-s' -o=./bin/api ./cmd/api
	GOOS=linux GOARCH=amd64 go build -ldflags='-s' -o=./bin/linux_amd64/api ./cmd/api

.PHONY: run/api 
run/api: ## run the cmd/api application
	go run ./cmd/api

.PHONY: test
test: # run all tests
	go test ./...

.PHONY: test/cover
test/cover: # run coverage checker
	go test -cover ./...

# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #

.PHONY: audit
audit: vendor ## tidy and vendor dependencies and format, vet and test all code
	@echo 'Formatting code…'
	go fmt ./...
	@echo 'Vetting code…'
	go vet ./...
	staticcheck ./...
	@echo 'Running tests…'
	go test -race -vet=off ./...

.PHONY: vendor
vendor: ## tidy and vendor dependencies
	@echo 'Tidying and verifying module dependencies…'
	go mod tidy
	go mod verify
	@echo 'Vendoring dependencies…'
	go mod vendor

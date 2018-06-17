VERSION  := 0.2.0
BIN_NAME := gcsproxy

GOFILES_NOVENDOR    := $(shell find . -type f -name '*.go' -not -path "*/vendor/*")
GOPACKAGES_NOVENDOR := $(shell dep ensure)

all: bin/$(BIN_NAME)

bin/$(BIN_NAME):
	if [ ! -d ./vendor ]; then dep ensure; fi
	CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o $@ .

container:
	cp bin/gcsproxy deploy/
	docker build -t gcsproxy deploy

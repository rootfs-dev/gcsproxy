BIN_NAME := gcsproxy

GOPACKAGES_NOVENDOR := $(shell dep ensure)

all: bin/$(BIN_NAME) container

bin/$(BIN_NAME): main.go
	if [ ! -d ./vendor ]; then dep ensure; fi
	CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o $@ .

container: bin/$(BIN_NAME)
	cp bin/gcsproxy deploy/
	docker build -t gcsproxy deploy

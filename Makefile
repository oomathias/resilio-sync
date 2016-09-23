all: build

build:
	@docker build --tag=oomathias/resilio-sync .

release: build
	@docker build --tag=oomathias/resilio-sync:$(shell cat VERSION) .

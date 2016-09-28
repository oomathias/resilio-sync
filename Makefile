all: build

build:
	@docker build --tag=oomathias/resilio-sync .

squash: build
	@docker save oomathias/resilio-sync | sudo docker-squash -from root -t squash | docker load

release: build
	@docker tag oomathias/resilio-sync oomathias/resilio-sync:$(shell cat VERSION)

all: build

%:
  @:

build:
	@docker build --tag=oomathias/resilio-sync .

squash: build
	@docker save oomathias/resilio-sync | sudo docker-squash | docker load

release: squash
	@docker tag oomathias/resilio-sync oomathias/resilio-sync:$(shell cat VERSION)

run: build
	@docker run --rm=true -it -p 8888:8888 -p 55555 oomathias/resilio-sync $(filter-out $@,$(MAKECMDGOALS))

run :
	docker run -it --rm immutable-builder:latest

build : build-docker

build-docker :
	docker build -t made2591/immutable-builder .

clean :
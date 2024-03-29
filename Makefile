UBUNTU=rolling

build:
	docker build --build-arg UBUNTU=$(UBUNTU) .

buildx:
	# docker buildx build --progress plain --platform linux/amd64,linux/arm64,linux/arm/v7 --build-arg UBUNTU=$(UBUNTU) --push -t glomium/cfssl:multiarch .
	docker buildx build --progress plain --platform linux/amd64 --build-arg UBUNTU=$(UBUNTU) --push -t glomium/cfssl:multiarch .

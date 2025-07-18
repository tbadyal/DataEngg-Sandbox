WORK_DIR ?= $(pwd)
DOCKER_ACCOUNT ?= tbadyal
IMAGE_VERSION ?= latest
IMAGE_NAME ?= fil-dataengg-sandbox

build:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION) --load .

build-amd64:
	docker buildx build --platform linux/amd64 -t $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-amd64:$(IMAGE_VERSION) --load .

build-arm64:
	docker buildx build --platform linux/arm64 -t $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-arm64:$(IMAGE_VERSION) --load .

run:
	docker run -it --rm -p 8888:8888 -v "$(WORK_DIR):/home/appuser/work" --user appuser $(DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

run-amd64:
	docker run -it --rm -p 8888:8888 -v "$(WORK_DIR):/home/appuser/work" --user appuser $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-amd64:$(IMAGE_VERSION)

run-arm64:
	docker run -it --rm -p 8888:8888 -v "$(WORK_DIR):/home/appuser/work" --user appuser $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-arm64:$(IMAGE_VERSION)

inspect:
	docker buildx imagetools inspect $(DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

inspect-amd64:
	docker buildx imagetools inspect $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-amd64:$(IMAGE_VERSION)

inspect-arm64:
	docker buildx imagetools inspect $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-arm64:$(IMAGE_VERSION)

push:
	docker push $(DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

push-amd64:
	docker push $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-amd64:$(IMAGE_VERSION)

push-arm64:
	docker push $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-arm64:$(IMAGE_VERSION)

pull:
	docker pull $(DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

pull-amd64:
	docker pull $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-amd64:$(IMAGE_VERSION)

pull-arm64:
	docker pull $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-arm64:$(IMAGE_VERSION)



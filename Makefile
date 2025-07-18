WORK_DIR ?= C:\Users\tusha\work
DOCKER_ACCOUNT ?= tbadyal
IMAGE_VERSION ?= latest
IMAGE_NAME ?= fil-dataengg-sandbox

freeze:
	pip freeze > constraints.txt

install:
	pip install -r requirements.txt

build:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION) .

build-amd64:
	docker buildx build --platform linux/amd64 -t $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-amd64:$(IMAGE_VERSION) .

build-arm64:
	docker buildx build --platform linux/arm64 -t $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-amd64:$(IMAGE_VERSION)  .

run:
	docker run -it --rm -p 8888:8888 -v "$(WORK_DIR):/home/appuser/work" --user appuser $(DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

run-amd64:
	docker run -it --rm -p 8888:8888 -v "$(WORK_DIR):/home/appuser/work" --user appuser $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-amd64:$(IMAGE_VERSION)

run-arm64:
	docker run -it --rm -p 8888:8888 -v "$(WORK_DIR):/home/appuser/work" --user appuser $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-arm64:$(IMAGE_VERSION)

push:
	docker push $(DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

push-amd64:
	docker push $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-amd64:$(IMAGE_VERSION)

push-arm64:
	docker push $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-arm64:$(IMAGE_VERSION)

history:
	docker history --no-trunc $(DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

history-amd64:
	docker history --no-trunc $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-amd64:$(IMAGE_VERSION)

history-arm64:
	docker history --no-trunc $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-amd64:$(IMAGE_VERSION)

dive:
	docker dive $(DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

dive-amd64:
	docker dive $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-amd64:$(IMAGE_VERSION)

dive-arm64:
	docker dive $(DOCKER_ACCOUNT)/$(IMAGE_NAME)-amd64:$(IMAGE_VERSION)

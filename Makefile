WORK_DIR ?= $(pwd)
DOCKER_ACCOUNT ?= tbadyal
IMAGE_VERSION ?= latest
IMAGE_NAME ?= fil-dataengg-sandbox

build:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION) --push .

run:
	docker run -it --rm -p 8888:8888 -v "$(WORK_DIR):/home/appuser/work" --user appuser $(DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

inspect:
	docker buildx imagetools inspect $(DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

pull:
	docker pull $(DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION)

install:
	pip install -r requirements.txt
	pip freeze > constraints.txt

WORK_DIR ?= $(pwd)
DOCKER_ACCOUNT ?= tbadyal
IMAGE_VERSION ?= 1.0.0
IMAGE_NAME ?= dataengg-sandbox

build:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(DOCKER_ACCOUNT)/$(IMAGE_NAME):$(IMAGE_VERSION) -t $(DOCKER_ACCOUNT)/$(IMAGE_NAME):latest --push .

run:
	docker run -it --rm -p 8888:8888 -v "$(WORK_DIR):/home/appuser/work" --user appuser $(DOCKER_ACCOUNT)/$(IMAGE_NAME)

inspect:
	docker buildx imagetools inspect $(DOCKER_ACCOUNT)/$(IMAGE_NAME)

pull:
	docker pull $(DOCKER_ACCOUNT)/$(IMAGE_NAME)

install:
	pip install -r requirements.txt
	pip freeze > constraints.txt

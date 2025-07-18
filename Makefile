freeze:
	pip freeze > constraints.txt

install:
	pip install -r requirements.txt

build-amd64:
	docker buildx build --platform linux/amd64 -t tbadyal/fil-dataengg-sandbox-amd64:latest .

build-arm64:
	docker buildx build --platform linux/arm64 -t tbadyal/fil-dataengg-sandbox-amd64:latest .

run-amd64:
	docker run --it --rm -p 8888:8888 -v "$(pwd):/home/appuser/work" --user appuser tbadyal/fil-dataengg-sandbox-amd64:latest

run-arm64:
	docker run --it --rm -p 8888:8888 -v "$(pwd):/home/appuser/work" --user appuser tbadyal/fil-dataengg-sandbox-arm64:latest

push-amd64:
	docker push tbadyal/fil-dataengg-sandbox-amd64:latest

push-arm64:
	docker push tbadyal/fil-dataengg-sandbox-arm64:latest


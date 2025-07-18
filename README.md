# FIL-DataEngg-Sandbox
FIL Data Engineering Sandbox
docker buildx build --platform linux/amd64 -t tbadyal/fil-dataengg-sandbox-amd64:latest .
docker run --it --rm -p 8888:8888 -v "$(pwd):/home/appuser/work" --user appuser fil-dataengg-sandbox:latest
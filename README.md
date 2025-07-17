# FIL-DataEngg-Sandbox
FIL Data Engineering Sandbox
docker buildx build --platform linux/arm64,|inux/amd64 —t tbadyaI/fiI—dataengg-sandbox:latest --push . docker
run —it --rm -p 8888:8888 -v "$(pwd):/home/appuser/work" «user appuser fil-dataengg-sandbox:latest
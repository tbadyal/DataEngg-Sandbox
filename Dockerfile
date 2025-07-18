FROM --platform=$TARGETPLATFORM python:3.11-slim AS build
LABEL author="Tushar Badyal"
LABEL copyright="Fide1ity International"
ARG TARGETPLATFORM
ARG TARGETARCH
ARG SPARK_VERSION=3.5.1
ARG HADOOP_VERSION=3
ARG OPENJDK_VERSION=17

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates openjdk-${OPENJDK_VERSION}-jdk-headless curl && \
    update-ca-certificates && \
    apt-get clean

RUN curl -L "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" \
    | tar xz -C /opt
RUN cp -r /usr/lib/jvm/java-${OPENJDK_VERSION}-openjdk-${TARGETARCH} /opt/jvm && \
    cp -r /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark

FROM --platform=$TARGETPLATFORM python:3.11-slim AS final
LABEL author="Tushar Badyal"
LABEL copyright="Fidelity International"
ARG TARGETPLATFORM
ARG UID=1000
ARG GID=1000

RUN groupadd -g "${GID}" appuser && useradd -u "${UID}" -g "${GID}" --create-home appuser
WORKDIR /home/appuser
COPY --from=build /opt/jvm /home/appuser/.local/jvm
COPY --from=build /opt/spark /home/appuser/.local/spark

RUN chown -R appuser:appuser /home/appuser
USER appuser
ENV JAVA_HOME=/home/appuser/.local/jvm
ENV SPARK_HOME=/home/appusen/.local/spark
ENV PATH=${JAVA_HOME}/bin:${PATH}
ENV PATH=${SPARK_HOME}/bin:${PATH}
ENV PATH=/home/appuser/.local/bin:${PATH}

COPY requirements.txt constraints.txt ./

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

RUN pip install --user --no-cache-dir --verbose \
    -r requirements.txt -c constraints.txt \
    --index-url=https://pypi.org/simple/ \
    --trusted-host=pypi.org \
    --trusted-host=files.pythonhosted.org

EXPOSE 8888
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD curl --fail http://localhost:8888/lab || exit 1
ENTRYPOINT ["jupyter" ,"lab", "--ip=0.0.0.0", "--no-browser"]
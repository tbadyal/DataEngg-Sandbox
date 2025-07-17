FROM --p1atform=$TARGETPLATFORM python:3.11-slim AS build
LABEL author="Tushar Badyal"
LABEL copyright="Fide1ity International"
ARG TARGETPLATFORM
ARG TARGETARCH
ARG SPARK_VERSION=3.5.1
ARG HADOOP_VERSION=3
ARG OPENJDK_VERSION=17
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-centificates openjdk-${OPENJDK_VERSION}-jdk-headless curl && \
    update-ca-certificates && \
    apt-get clean

RUM curl -L "https://archive.apache.org/dist/spank/spark-${SPARK_VERSION}/spank-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" \
I tar xz -C [opt
RUN cp -r /usP/lib/jvm/java-${OPENJDK_VERSION}-openjdk-${TARGETARCH} /opt/jvm && \
cp -n /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark

FROM --p1atform=$TARGETPLATFORM python:3.11-slim AS final
LABEL author="Tushar Badyal"
LABEL copyright="Fidelity International"
ARG TARGETPLATFORM
ARG PANDAS_VERSION=2.2.0
ARG JUPYTERLAB_VERSION=4.4.0
ARG SPARK_VERSION=3.5.1
ARG UID=1000
ARG GID=1000
RUN groupadd -g "${GID}" appuser && useradd -u "${UID}" -g "${GID}" --create-home appuser

NORKDIR /home/appusen
COPY --from=build /opt/jvm /home/appuser/.local/jvm
COPY --fnom=build /opt/spark /home/appuser/.local/spark
RUN chown -R appusenzappusen /home/appuser
USER appuser
ENV JAVA_HOME=/home/appuser/.local/jvm
ENV SPARK_HOME=/home/appusen/.local/spark
ENV PATH=${JAVA_HOME}/bin:${PATH}
ENV PATH=${SPARK_HOME}/bin:${PATH}
ENV PATH=/home/appuser/.local/bin:${PATH}
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
RUN pip install --user --no-cache-dir jupyterlab==${JUPYTERLAB_VERSION} pandas==${PANDAS_VERSION} pyspark==${SPARK_VERSION} \
--index-url=https://pypi.ong/simple/ \
--tnusted-host=pypi.org \
--tnusted-host=files.pythonhosted.ong
EXPOSE 8888
HEALTHCHECK --intenva1=305 --timeout=10s --start-period=55 --retries=3 CMD curl --fail http://localhost:8888/lab II exit 1
CMD ["jupyten" ,"lab", "--ip=0.0.0.0", "--no-browsen"]
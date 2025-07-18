FROM --platform=$TARGETPLATFORM python:3.11-slim-bullseye

# Arguments
ARG SPARK_VERSION=3.5.1
ARG HADOOP_VERSION=3
ARG OPENJDK_VERSION=17
ARG TARGETARCH
ARG UID=1000
ARG GID=1000

# Environment
ENV HOME=/home/appuser \
    LOCAL_PREFIX=/home/appuser/.local \
    JAVA_HOME=/usr/lib/jvm/java-${OPENJDK_VERSION}-openjdk-${TARGETARCH} \
    SPARK_HOME=/opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}

# Install only necessary packages and clean up immediately
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates build-essential openjdk-${OPENJDK_VERSION}-jdk-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Apache Spark
RUN curl -fsSL "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" \
    | tar xz -C /opt && \
    apt-get purge --auto-remove -y curl build-essential

# Create non-root user early for cache efficiency
RUN groupadd -g ${GID} appuser && \
    useradd -m -u ${UID} -g ${GID} --create-home appuser && \
    chown -R appuser:appuser $HOME

# Switch to non-root user
USER appuser
WORKDIR $HOME

# Python Environment
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH="${LOCAL_PREFIX}/bin:/opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/bin:/usr/lib/jvm/java-${OPENJDK_VERSION}-openjdk-${TARGETARCH}/bin:$PATH"

# Copy requirements early for layer caching
COPY --chown=appuser:appuser requirements.txt constraints.txt /tmp/

# Install Python packages to --user and clean cache
RUN pip install --user --no-cache-dir --no-compile \
    -r /tmp/requirements.txt -c /tmp/constraints.txt && \
    rm -rf /tmp/* ~/.cache/pip

# Expose port and healthcheck
EXPOSE 8888
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl --fail http://localhost:8888/lab || exit 1

# Entry point
ENTRYPOINT ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--NotebookApp.token=''", "--ServerApp.allow_origin='*'", "--ServerApp.allow_remote_access=True"]

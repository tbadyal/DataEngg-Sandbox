# ----------- Stage 1: Build ----------------
FROM --platform=$TARGETPLATFORM python:3.11-slim-bullseye AS build

# Arguments
ARG SPARK_VERSION=3.5.1
ARG HADOOP_VERSION=3
ARG OPENJDK_VERSION=17
ARG TARGETARCH

# Install build tools and openjdk
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl build-essential rsync openjdk-${OPENJDK_VERSION}-jdk-headless && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Download Spark
RUN curl -fsSL "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" \
    | tar xz -C /opt && \
    mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark && \
    mv /usr/lib/jvm/java-${OPENJDK_VERSION}-openjdk-${TARGETARCH} /opt/jvm

# Copy Python requirements
COPY requirements.txt constraints.txt ./

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Install Packages
RUN pip install --prefix=/opt/python --no-cache-dir --no-compile \
    -r requirements.txt -c constraints.txt \
    --index-url=https://pypi.org/simple/ \
    --trusted-host=pypi.org \
    --trusted-host=files.pythonhosted.org

RUN rsync -a \
    --exclude='*.py[cod]' \
    --exclude='__pycache__/' \
    --exclude='test*/' \
    --exclude='doc*/' \
    /opt/python/ /opt/pruned-python/

# ----------- Stage 2: Final ----------------
FROM --platform=$TARGETPLATFORM python:3.11-slim-bullseye AS final

ARG UID=1000
ARG GID=1000

# Environment
ENV HOME=/home/appuser
ENV LOCAL_PREFIX=$HOME/.local
ENV JAVA_HOME=$LOCAL_PREFIX/jvm
ENV SPARK_HOME=$LOCAL_PREFIX/spark
ENV PYTHON_HOME=$LOCAL_PREFIX

# Create non-root user
RUN groupadd -g ${GID} appuser && \
    useradd -u ${UID} -g ${GID} --create-home appuser
# Set WorkDir
WORKDIR $HOME

# Copy binaries from build
COPY --from=build /opt/jvm $JAVA_HOME
COPY --from=build /opt/spark $SPARK_HOME
COPY --from=build /opt/pruned-python $PYTHON_HOME

# Set permissions
RUN chown -R appuser:appuser $HOME

# Switch to appuser
USER appuser

# Environment Variables
ENV PATH=$JAVA_HOME/bin:$SPARK_HOME/bin:$PYTHON_HOME/bin:$PATH
ENV PYTHONPATH=$PYTHON_HOME/lib/python3.11/site-packages
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Run Jupyter lab
EXPOSE 8888
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl --fail http://localhost:8888/lab || exit 1

# Entry
ENTRYPOINT ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--NotebookApp.token=''", "--ServerApp.allow_origin='*'", "--ServerApp.allow_remote_access=True"]

FROM gcr.io/buildpacks/builder:v1
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
  libpq-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
USER cnb
# Base Docker images for Python
This repo includes Docker images for Python applications based off
[_busybox_](https://hub.docker.com/_/busybox) images with
[glibc](https://sourceware.org/glibc) or [musl](https://musl.libc.org).

Python installation is taken from the official _slim_ and _alpine_ images and
cleaned using _clean_python_image.sh_ script.

Each image includes SSL certificates and essential libraries (_readline_, _ssl_,
_ffi_, _sqlite3_, etc.).

_pip_ package manager is removed so consider using external _uv_ as shown below:
```dockerfile
FROM ghcr.io/astral-sh/uv:0.5.14 AS uv
COPY pyproject.toml uv.lock /

FROM python:3.12-musl
# https://docs.astral.sh/uv/concepts/python-versions/#disabling-automatic-python-downloads
ENV UV_PYTHON_DOWNLOADS=never
# for uv sync https://docs.astral.sh/uv/concepts/projects/config/#project-environment-path
ENV UV_PROJECT_ENVIRONMENT=/usr/local

USER root
RUN --mount=from=uv,source=/uv,target=/bin/uv \
    --mount=from=uv,source=/pyproject.toml,target=/pyproject.toml \
    --mount=from=uv,source=/uv.lock,target=/uv.lock \
  # Install dependencies from an existing uv.lock
  uv sync --frozen --no-cache --no-dev --no-install-project
USER app
COPY --chown=app:app ./application /application
```

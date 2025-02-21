# Using an image that includes uv
FROM ghcr.io/astral-sh/uv:python3.13-alpine AS base

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=never

# Change the working directory to the `app` directory
WORKDIR /app

FROM base AS reqs-compile

COPY pyproject.toml uv.lock ./

# Install dependencies
# RUN --mount=type=cache,target=/root/.cache/uv \
#   --mount=type=bind,source=uv.lock,target=uv.lock \
#   --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
#   uv sync --frozen --no-install-project --group prod

# Compile to a requirements file
RUN uv pip compile /app/pyproject.toml --generate-hashes -o /app/requirements.txt

# Use an image without uv to install dependencies and run the server
FROM python:3.13-alpine AS release

WORKDIR /app

# Set environment variables
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Copy the application from the builder
COPY --from=reqs-compile --chown=app:app /app/requirements.txt .

RUN pip install -r /app/requirements.txt

COPY . .

# Place executables in the environment at the front of the path
# ENV PATH="/app/.venv/bin:$PATH" \
#   PYTHONPATH="/app"

EXPOSE 8000

# Give access permissions to the bash script
RUN chmod +x /app/entrypoint.sh

# Run the Django application by Gunicorn
ENTRYPOINT [ "sh", "/app/entrypoint.sh" ]

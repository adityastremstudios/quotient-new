# ============================================================
# 🏗️ Stage 1: Builder (install dependencies using Poetry)
# ============================================================
FROM python:3.11-buster AS builder

# Install system dependencies required by your packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libffi-dev \
    libjpeg-dev \
    zlib1g-dev \
    libtesseract-dev \
    tesseract-ocr \
    wkhtmltopdf \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install --no-cache-dir poetry==1.5.1

# Set Poetry environment
ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

WORKDIR /app

# Copy dependency files first (for better layer caching)
COPY pyproject.toml poetry.lock ./
RUN touch README.md

# Install dependencies (excluding dev dependencies)
RUN --mount=type=cache,target=$POETRY_CACHE_DIR \
    poetry install --without dev --no-root

# ============================================================
# 🚀 Stage 2: Runtime (smaller final image)
# ============================================================
FROM python:3.11-slim-buster AS runtime

# Install only runtime dependencies (smaller footprint)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    libjpeg62-turbo \
    zlib1g \
    tesseract-ocr \
    wkhtmltopdf \
    && rm -rf /var/lib/apt/lists/*

# Setup environment
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    VIRTUAL_ENV=/app/.venv \
    PATH="/app/.venv/bin:$PATH"

WORKDIR /app

# Copy virtual environment from builder stage
COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}

# Copy source code
COPY src src
COPY config.py config.py

# Optional: copy .git directory if needed (for version info)
COPY .git .git

# Healthcheck (optional for uptime monitors)
# HEALTHCHECK CMD python -m src.healthcheck || exit 1

# Entrypoint
ENTRYPOINT ["python", "src/bot.py"]

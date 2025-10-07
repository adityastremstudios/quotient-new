# ============================================================
# 🏗️ Stage 1: Builder (install dependencies using Poetry or pip)
# ============================================================
FROM python:3.11-buster AS builder

# Install required system libraries for building packages
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

WORKDIR /app

# Copy your dependency files
COPY requirements.txt .

# Install all Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# ============================================================
# 🚀 Stage 2: Runtime (lighter production image)
# ============================================================
FROM python:3.11-slim-buster AS runtime

# Install only runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    libjpeg62-turbo \
    zlib1g \
    tesseract-ocr \
    wkhtmltopdf \
    && rm -rf /var/lib/apt/lists/*

# Set up environment
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# Copy dependencies from builder
COPY --from=builder /usr/local /usr/local

# Copy your source code
COPY src src
COPY config.py config.py

# No .git folder — removed to avoid checksum error
# COPY .git .git   # ❌ removed

# Default command to start the bot
ENTRYPOINT ["python", "src/bot.py"]

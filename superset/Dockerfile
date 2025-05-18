FROM apache/superset:4.1.2

# Copy requirements first
COPY requirements.txt /tmp/requirements.txt

USER root
# install postgres client
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Create directory for Celery Beat schedule and set ownership
RUN mkdir -p /beat_data && \
    chown superset:superset /beat_data
# Copy Superset configuration
COPY superset_config.py /app/superset_config.py
COPY helpers.py /app/superset/helpers.py

USER superset

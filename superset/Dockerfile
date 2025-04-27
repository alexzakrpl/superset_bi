FROM apache/superset:4.1.2

# Copy requirements first
COPY requirements.txt /tmp/requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Create directory for Celery Beat schedule and set ownership
USER root
RUN mkdir -p /beat_data && \
    chown superset:superset /beat_data
USER superset

# Copy Superset configuration
COPY superset_config.py /app/superset_config.py


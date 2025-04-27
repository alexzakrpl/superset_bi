import os
from celery.schedules import crontab

# Database connection (Superset metadata)
SQLALCHEMY_DATABASE_URI = "postgresql://superset:superset@postgres:5432/superset"

# Celery broker (Redis)
CELERY_BROKER_URL = "redis://redis:6379/0"
CELERY_RESULT_BACKEND = "redis://redis:6379/0"

# Cache settings
CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_DEFAULT_TIMEOUT": 300,
    "CACHE_KEY_PREFIX": "superset_",
    "CACHE_REDIS_URL": "redis://redis:6379/0",
}

# Enable async queries (SQL Lab async execution)
FEATURE_FLAGS = {
    "ENABLE_ASYNC_QUERIES": True,
    "KV_STORE": True,
    "DASHBOARD_NATIVE_FILTERS": True,
    "ALERT_REPORTS": True,
}

# Celery Beat schedule for periodic tasks
CELERYBEAT_SCHEDULE = {
    "clear_cache": {
        "task": "superset.tasks.cache.clear",
        "schedule": crontab(minute="0", hour="3"),  # Clear cache every day at 3 AM
    },
}

# Celery imports
CELERY_IMPORTS = ("superset.tasks",)

# Webserver timeout settings
SUPERSET_WEBSERVER_TIMEOUT = 120

# Allowed origins for CORS
ENABLE_CORS = True
CORS_OPTIONS = {
    "supports_credentials": True,
    "allow_headers": ["*"],
    "expose_headers": ["*"],
    "origins": ["*"],
}

# Secret key for session management (should be set securely via env)
SECRET_KEY = os.getenv("SUPERSET_SECRET_KEY", "thisISaSECRET_key_change_me")

# Session cookie settings
SESSION_COOKIE_SECURE = True
SESSION_COOKIE_HTTPONLY = True
SESSION_COOKIE_SAMESITE = "Lax"


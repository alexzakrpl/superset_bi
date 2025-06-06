# Superset BI Deployment

This repository contains a production-ready Docker Compose setup for deploying Apache Superset along with PostgreSQL, Redis, and Celery components.

## Requirements

- Docker Engine >= 20.10
- Docker Compose plugin >= 2.0
- GNU Make (optional but recommended for faster commands)
- Bash >= 5.0

## Project Structure

```
superset_bi/
├── docker-compose.yml        # Main orchestration file
├── superset/                  # Custom Superset configuration
│   ├── Dockerfile             # Custom image build for Superset
│   ├── requirements.txt       # Additional Python dependencies
│   ├── superset_config.py     # Superset configuration (PostgreSQL, Redis, Caching)
│   └── helpers.py             # Updated file with fixed examples bug
├── .env.example               # Example of default environment variables (should be updated before deployment and saved as .env)
├── deploy_superset.sh         # Bash script for full project deployment
└── README.md                  # This documentation file
```

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/alexzakrpl/superset_bi.git
cd superset_bi
```

### 2. Review and update the `.env` file

This project comes with a default `.env` file containing initial credentials.\
It is strongly recommended to **change all passwords and secret keys** before the first deployment.

Default environment variables provided:

```env
SUPERSET_ADMIN_USERNAME=admin
SUPERSET_ADMIN_FIRSTNAME=Admin
SUPERSET_ADMIN_LASTNAME=User
SUPERSET_ADMIN_EMAIL=youremail@mailbox.com
SUPERSET_ADMIN_PASSWORD=securepassword
SUPERSET_SECRET_KEY=this_should_be_really_secure
SUPERSET_WEBSERVER_PORT=8088
SUPERSET_POSTGRES_PORT=5432
```

You must replace `SUPERSET_SECRET_KEY` with a strong unique value.

Example for generating a secure key:

```bash
python3 -c 'import secrets; print(secrets.token_urlsafe(64))'
```

Replace all sensitive values before proceeding.

### 3. Make the deployment script executable

```bash
chmod +x deploy_superset.sh
```

### 4. Deploy the project

Run the deployment script:

```bash
./deploy_superset.sh
```

The script will:

- Load environment variables from `.env`
- Create necessary Docker volumes
- Build Docker images
- Launch all services
- Display running containers

After successful deployment, Superset will be available at:

```
http://localhost:8088
```

Log in using the credentials defined in `.env`.

---

## Services Overview

| Service       | Purpose                      | Port Mapping |
| ------------- | ---------------------------- | ------------ |
| Superset      | Web application              | 8088:8088    |
| PostgreSQL    | Superset metadata database   | 5432:5432    |
| Redis         | Message broker for Celery    | 6379:6379    |
| Celery Worker | Background tasks executor    | internal     |
| Celery Beat   | Scheduler for periodic tasks | internal     |

---

## Important Notes

- Default Superset admin account is created automatically during the initial setup.
- `pg_data` and `beat_data` volumes are created automatically for PostgreSQL and Celery Beat persistence.
- If you need to reinitialize the environment, remember to clear old volumes:

```bash
docker volume rm superset_bi_pg_data
docker volume rm superset_bi_beat_data
```

---

## How to Stop the Services

```bash
docker compose down
```

All containers will be stopped, but volumes will remain unless manually deleted.

---

## Recommended Improvements

For a production environment:

- Configure SSL/TLS for external access.
- Store secret environment variables securely.
- Use an external Redis or PostgreSQL service if scaling is needed.
- Consider using RedBeat for distributed task scheduling.

---

# End of README


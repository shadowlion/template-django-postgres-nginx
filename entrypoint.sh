#!/bin/sh

# Apply database migrations
python manage.py migrate --no-input

# Collect static files (if needed)
python manage.py collectstatic --no-input

# Start Gunicorn server
exec gunicorn --bind 0.0.0.0:8000 --workers 4 project.wsgi:application

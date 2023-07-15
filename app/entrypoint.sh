#!/usr/bin/env bash
# Script entrypoint.sh starts your app.
exec gunicorn app:app --bind=${HOST:-0.0.0.0}:${PORT:-8080}

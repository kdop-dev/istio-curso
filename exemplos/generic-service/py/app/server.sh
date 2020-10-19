#!/bin/sh
echo "started at :8000"
echo "health at http://localhost:8000/healthz"

# Dev
# uvicorn main:app --reload

# Prd
uvicorn --host=0.0.0.0 --port=8000 --workers=2 --forwarded-allow-ips=* --proxy-headers main:app
#!/bin/sh
echo "started at :8000"
echo "health at http://localhost:8000/healthz"

julia main.jl -q -i
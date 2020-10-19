# Generic Service

```bash
CALL_SERVICES=orders,catalogue CALL_INTERVAL=1 uvicorn main:app --reload
```

## Build

```bash
docker build -t kdop/generic-service:0.0.1 .
```

## Run

```bash
# Create net
docker network create my-net

# backend
docker run -d --rm \
--hostname backend \
--network my-net \
--name backend \
-e SCHED_CALL_URL_LST=http://localhost:8000/healthz \
-e SCHED_CALL_INTERVAL=5 \
kdop/generic-service:0.0.1

# front-end
docker run -d --rm \
    --network my-net \
    --hostname front-end \
    --name front-end \
    -e SCHED_CALL_URL_LST=http://front-end:8000,http://localhost:8000/healthz,http://backend:8000 \
    -e SCHED_CALL_INTERVAL=10 \
    -e SPLIT_CALL_URL_LST=http://backend:8000 \
    kdop/generic-service:0.0.1

# Clean-up
docker network rm my-net
```

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
# front-end
docker run -d --rm --link backend --hostname front-end --name front-end -e CALL_SERVICES=front-end:8000,localhost:8000/healthz,backend:8000 -e CALL_INTERVAL=10 kdop/generic-service:0.0.1

# backend
docker run -d --rm --hostname backend --name backend -e CALL_SERVICES=localhost:8000/healthz -e CALL_INTERVAL=10 kdop/generic-service:0.0.1
```

# Generic Service

```bash
CALL_SERVICES=orders,catalogue CALL_INTERVAL=1 uvicorn main:app --reload
```

## Build

```bash
docker build -t kdop/generic-service:0.0.1 .
```

## Push to docker hub

```bash
docker push kdop/generic-service:0.0.1
```

## Run

simple-app

![simple app demo](../../../media/simul-shop-fb.png)

```bash
# Create net
docker network create my-net

# backend
docker run -d --rm \
--hostname backend \
--network my-net \
--name backend \
kdop/generic-service:0.0.1

# front-end
docker run -d --rm \
    --network my-net \
    --hostname front-end \
    --name front-end \
    -e SCHED_CALL_URL_LST=http://front-end:8000/s \
    -e SCHED_CALL_INTERVAL=10 \
    -e SPLIT_CALL_URL_LST=http://backend:8000 \
    kdop/generic-service:0.0.1
```

## Logs

```bash
# Terminal 1
docker logs -f backend

# Terminal 2
docker logs -f front-end
```

## Clean-up

```bash
docker kill front-end backend
docker network rm my-net
```
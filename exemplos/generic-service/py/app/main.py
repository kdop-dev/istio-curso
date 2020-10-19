from typing import Optional
from fastapi import FastAPI
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.interval import IntervalTrigger
import atexit
import os
import time
import requests
import logging
import asyncio
from pydantic import BaseModel
#from fastapi_opentracing import get_opentracing_span_headers
#from fastapi_opentracing.middleware import OpenTracingMiddleware
from fastapi_contrib.tracing.middlewares import OpentracingMiddleware
from fastapi_contrib.tracing.utils import setup_opentracing

#* --- APP --- #
app = FastAPI()

#app.add_middleware(OpenTracingMiddleware)

# Opentracing
@app.on_event('startup')
async def startup():
    setup_opentracing(app)
    app.add_middleware(OpentracingMiddleware)

SCHED_CALL_URL_LST = os.getenv("SCHED_CALL_URL_LST") or ""
SCHED_CALL_INTERVAL = os.getenv("SCHED_CALL_INTERVAL") or "10"
SPLIT_CALL_URL_LST = os.getenv("SPLIT_CALL_URL_LST") or ""

logging.basicConfig(format='%(levelname)s: %(asctime)s - %(message)s', level=logging.INFO)

class MessageOut(BaseModel):
    name: str
    description: Optional[str] = None

    class Config:
        schema_extra = {
            "example": {
                "name": "message_type",
                "description": "any description or value",
            }
        }

#* --- UTILS --- #
def invoke_ws_list(url_list: list):
#async def invoke_ws_list(url_list: list):
    logging.debug('Invoked')
    logging.info(f'Calling: {url_list}')
    for url in url_list:
        if url:
            try:
                response = requests.get(url)
                logging.info(f"headers: {response.headers}")
                logging.info(f"body: {response.content}")
            except Exception as err:
                logging.error(f"Failed reaching {url} - {err}")

#* --- ROUTES --- #
# root
@app.get("/", response_model=MessageOut)
async def root():
    #carrier = await get_opentracing_span_headers()
    #logging.info(f"opentracing: {carrier}")
    message = MessageOut(name="greetings", description="Hi there!")
    return message

# Split
# TODO: Pass headers for opentracing
@app.get("/s", response_model=MessageOut)
async def split():
    #carrier = await get_opentracing_span_headers()
    #logging.info(f"opentracing: {carrier}")
    url_list = SPLIT_CALL_URL_LST.split(",")
    message = MessageOut(name="split", description=f"List {url_list}")
    invoke_ws_list(url_list)
    #await invoke_ws_list(url_list)
    return message

# Health
@app.get("/healthz", response_model=MessageOut)
async def health():
    #carrier = await get_opentracing_span_headers()
    message = MessageOut(name="status", description="health")
    return message

#* --- Scheduler -- #
def schedule_invoke_ws():
    logging.debug('Invoked')
    url_list = SCHED_CALL_URL_LST.split(",")
    #asyncio.run(invoke_ws_list(url_list))
    invoke_ws_list(url_list)

# create schedule for printing time
job_defaults = {
    'coalesce': False,
    'max_instances': 3
}
scheduler = BackgroundScheduler(job_defaults=job_defaults)
scheduler.start()
scheduler.add_job(
    func=schedule_invoke_ws,
    trigger=IntervalTrigger(seconds=int(SCHED_CALL_INTERVAL)),
    id='schedule_invoke_ws_job',
    name=f'Call url every {SCHED_CALL_INTERVAL} seconds',
    replace_existing=True)

# Shut down the scheduler when exiting the app
atexit.register(lambda: scheduler.shutdown())

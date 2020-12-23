#from logging import info
import logging
from typing import Optional
from fastapi import FastAPI, Request, HTTPException
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.interval import IntervalTrigger
import atexit
import os, time, datetime
import requests
from pydantic import BaseModel
from fastapi_opentracing import get_opentracing_span_headers
from fastapi_opentracing.middleware import OpenTracingMiddleware

#* --- APP --- #
app = FastAPI()
app.add_middleware(OpenTracingMiddleware)

SCHED_CALL_URL_LST = os.getenv("SCHED_CALL_URL_LST") or ""
SCHED_CALL_INTERVAL = os.getenv("SCHED_CALL_INTERVAL") or "10"
SPLIT_CALL_URL_LST = os.getenv("SPLIT_CALL_URL_LST") or ""
APP = os.getenv("APP") or ""
VERSION = os.getenv("VERSION") or ""

logging.basicConfig(format='%(levelname)s: %(asctime)s - %(message)s', level=logging.INFO)

class MessageOut(BaseModel):
    name: str
    description: Optional[str] = None
    app: Optional[str] = None
    version: Optional[str] = None
    when: Optional[str] = None

    class Config:
        schema_extra = {
            "example": {
                "name": "message_type",
                "description": "any description or value",
                "app": "app-name",
                "version": "version",
                "when": "%Y-%m-%d %H:%M:%S"
            }
        }

#* --- UTILS --- #
def invoke_ws_list(url_list: list, headers = {}):
    logging.debug('Invoked')
    logging.info(f'Calling: {url_list}')
    for url in url_list:
        if url:
            try:
                response = requests.get(url, headers=headers)
                logging.info(f"headers: {response.headers}")
                logging.info(f"body: {response.content}")
            except Exception as err:
                logging.error(f"Failed reaching {url} - {err}")


#* --- ROUTES --- #
# root
@app.get("/", response_model=MessageOut)
async def root():
    when = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    carrier = await get_opentracing_span_headers()
    logging.info(f"opentracing: {carrier}")
    message = MessageOut(name="greetings", description="Hi there!", when=when, app=APP, version=VERSION)
    return message

# return code
@app.get("/r")
async def resp(code: int = 200, wait: int = 0):
    when = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    carrier = await get_opentracing_span_headers()
    logging.info(f"opentracing: {carrier}")
    time.sleep(wait)
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    raise HTTPException(status_code=code, detail=f"At {when} this request asks for {code} and waits for {wait}s and now is {now}.")

# Split
# TODO: Return app, version, datetime
@app.get("/s", response_model=MessageOut)
async def split(request: Request):
    when = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    carrier = await get_opentracing_span_headers()
    logging.info(f"opentracing: {carrier}")
    logging.info(f"request.headers: {request.headers}")
    url_list = SPLIT_CALL_URL_LST.split(",")
    message = MessageOut(name="split", description=f"List {url_list}", when=when, app=APP, version=VERSION)
    invoke_ws_list(url_list, carrier)
    return message

# Health
@app.get("/healthz", response_model=MessageOut)
async def health():
    when = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    message = MessageOut(name="status", description="health", when=when, app=APP, version=VERSION)
    return message

#* --- Scheduler -- #
def schedule_invoke_ws():
    logging.debug('Invoked')
    url_list = SCHED_CALL_URL_LST.split(",")
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

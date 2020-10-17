from typing import Optional
from fastapi import FastAPI
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.interval import IntervalTrigger
import atexit
import time
import os
import requests

app = FastAPI()

CALL_SERVICES = os.getenv("CALL_SERVICES") or ""
CALL_INTERVAL = os.getenv("CALL_INTERVAL") or "5"

@app.get("/")
def read_root():
    return {"message": "Hi there!"}

@app.get("/healthz")
def read_root():
    return "Ok"

def schedule_invoke_ws():
    print(time.strftime('%H:%M:%S'))
    print(f'Calling: {CALL_SERVICES.split(",")}')
    for service in CALL_SERVICES.split(","):
        if service:
            try:
                response = requests.get(f"http://{service}")
                print(response.headers)
                print(response.content)
            except Exception as err:
                print(f"Failed reaching http://{service} - {err}")

# create schedule for printing time
scheduler = BackgroundScheduler()
scheduler.start()
scheduler.add_job(
    func=schedule_invoke_ws,
    trigger=IntervalTrigger(seconds=int(CALL_INTERVAL)),
    id='schedule_invoke_ws_job',
    name=f'Print time every {CALL_INTERVAL} seconds',
    replace_existing=True)

# Shut down the scheduler when exiting the app
atexit.register(lambda: scheduler.shutdown())

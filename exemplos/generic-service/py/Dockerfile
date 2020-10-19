FROM python:3.8-buster

WORKDIR /app

COPY ./app /app

RUN pip install -r /app/requirements.txt

EXPOSE 8000

CMD ["/app/server.sh"]
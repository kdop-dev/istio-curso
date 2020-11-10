FROM python:3.8-buster

RUN apt install dnsutils

WORKDIR /app

COPY ./app /app

RUN pip install -r /app/requirements.txt

EXPOSE 8000

CMD ["/app/server.sh"]
FROM python:3.8-buster

RUN apt-get update && apt-get install -y dnsutils httpie

WORKDIR /app

COPY ./app /app

RUN pip install -r /app/requirements.txt

EXPOSE 8000

#CMD ["/app/server.sh"]
CMD ["uvicorn", "--host=0.0.0.0", "--port=8000", "--workers=2", "--forwarded-allow-ips=*", "--proxy-headers", "main:app"]
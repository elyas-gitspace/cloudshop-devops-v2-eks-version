FROM python:3.12-alpine

WORKDIR /app/product-api

RUN apk add --update --no-cache python3 py3-pip gcc musl-dev python3-dev libffi-dev openssl-dev

COPY . .
RUN pip3 install -r requirements.txt --break-system-packages

EXPOSE 5000

CMD ["python3", "app.py"]
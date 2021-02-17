FROM python:3.7

RUN mkdir /app
WORKDIR /app

RUN apt-get update && apt-get install -y libpq-dev gcc python3-dev vim git

COPY requirements.txt /app
RUN pip3 install -r requirements.txt

COPY . /app

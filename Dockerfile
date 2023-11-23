FROM python:3.11-slim-buster

RUN apt-get update && \
    apt-get install -y curl make git && \
    apt-get clean

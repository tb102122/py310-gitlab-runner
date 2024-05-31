FROM python:3.12-slim-bookworm

RUN apt-get update && \
    apt-get install -y curl make git gcc unixodbc && \
    apt-get clean

FROM python:3

COPY ./src /opt/app

CMD ["python3", "-u", "main.py"]

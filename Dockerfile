FROM python:3.9-slim

WORKDIR /app

COPY /app /app/
COPY test_app.py /app/
RUN pip install flask pytest

CMD ["python", "app.py"]



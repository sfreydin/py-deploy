FROM python:alpine3.7
COPY src /app
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 8080
CMD python ./app.py

FROM python:alpine3.7
COPY . /app
WORKDIR /app
RUN apk add gcc && \
   pip3 install --upgrade pip && \
   pip3 install -r requirements.txt
EXPOSE 8080
CMD python ./src/app.py


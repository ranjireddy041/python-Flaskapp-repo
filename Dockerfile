FROM ubuntu:22.04 
WORKDIR /app 
RUN apt-get update -y && apt-get install python3 python3-pip && rm -rf var/lib/list/*
RUN pip install --no-cache-dir flask boto3
COPY app.py .
CMD ["python3", "app.py"]
EXPOSE 5000

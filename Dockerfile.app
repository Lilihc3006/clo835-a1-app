FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt /app/
RUN pip install -r requirements.txt
COPY app/ /app/
ENV PORT=8080 COLOR=blue
EXPOSE 8080
CMD ["python","app.py"]

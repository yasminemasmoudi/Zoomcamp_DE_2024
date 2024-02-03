
FROM python:3.9-slim
WORKDIR /app
# Copy the requirements file into the container
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# Copy the Python script into the container
COPY data_ingestion.py .
# Set the command to run the Python script
CMD ["python", "data_ingestion.py"]
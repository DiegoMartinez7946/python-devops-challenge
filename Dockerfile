# Use an official Python runtime as the base image
FROM python:3.9-slim as base

# Set the working directory in the container
WORKDIR /app

# Install the application dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Multi-stage build: Create a clean, final image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy necessary files from the base image
COPY --from=base /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/
COPY --from=base /usr/local/bin/ /usr/local/bin/

# Copy the application files to the container
COPY ./app /app/app
COPY config.py /app/
COPY run.py /app/

# Set the command to run the application
CMD ["python", "run.py"]

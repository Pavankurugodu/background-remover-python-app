# Use an official Python runtime as a parent image
#FROM python:3.9-slim

# Set the working directory inside the container
#WORKDIR /app

# Copy the requirements.txt file to the container
#COPY requirements.txt .

# Install the required packages
#RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app
#COPY . .

# Expose the port that the Flask app runs on
#EXPOSE 5100

# Command to run the Flask application using gunicorn for production
#CMD ["gunicorn", "--bind", "0.0.0.0:5100", "app:app", "--workers=4"]

# Stage 1: Build Stage
# Use a larger image for building the dependencies
FROM python:3.10-alpine as build-stage

# Set the working directory inside the container
WORKDIR /app

# Install dependencies for building wheels (required by some Python packages) and cleanup after install
RUN apk update && \
    apk add --no-cache gcc musl-dev libffi-dev

# Copy the requirements.txt file and install the dependencies
COPY requirements.txt ./

# Install the required packages
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Final Runtime Stage
# Use the official Python Alpine image (much smaller than the build stage)
FROM python:3.10-alpine as runtime-stage

# Set the working directory inside the container
WORKDIR /app

# Copy only the necessary files from the build stage to the runtime stage
COPY --from=build-stage /app /app

# Expose the port that the Flask app runs on
EXPOSE 5100

# Command to run the Flask application using gunicorn for production
CMD ["gunicorn", "--bind", "0.0.0.0:5100", "app:app", "--workers=4"]

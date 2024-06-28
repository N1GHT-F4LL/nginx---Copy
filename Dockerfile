# Use the official Nginx image as the base image
FROM nginx:1.27.0-bookworm

# Update and upgrade the system
RUN apt-get update && apt-get upgrade -y

# Install necessary packages without recommended packages to keep the image size small
RUN apt-get install -y --no-install-recommends bash python3 curl unzip ipvsadm iproute2 openrc keepalived procps && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Create directory for keepalived
RUN mkdir -p /usr/lib/keepalived

# Download and install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm awscliv2.zip && \
    rm -rf ./aws

# Copy the entrypoint script to the container
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint to the script
ENTRYPOINT ["/entrypoint.sh"]
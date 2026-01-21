# Keybase Git Dockerfile
# Docker image with Keybase CLI and Git for secure repository access

FROM ubuntu:22.04

# Install required packages
RUN apt-get update && apt-get install -y \
    bash \
    git \
    coreutils \
    curl \
    wget \
    ca-certificates

# Install keybase
RUN curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb && \
    apt-get install -y --fix-missing ./keybase_amd64.deb && \
    rm ./keybase_amd64.deb

# Clean up apt cache
RUN rm -rf /var/lib/apt/lists/*

# Set timezone (can be overridden with environment variable)
ENV TZ=UTC

# Create app directory
WORKDIR /workspace

# Create /app directory for scripts
RUN mkdir -p /app

# Copy entrypoint script (must be done as root)
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy keybase-init script (must be done as root)
COPY keybase-init.sh /app/keybase-init.sh
RUN chmod +x /app/keybase-init.sh

# Create a non-root user for security
RUN useradd -m -s /bin/bash gituser && \
    chown -R gituser:gituser /workspace && \
    chown gituser:gituser /entrypoint.sh && \
    chown gituser:gituser /app/keybase-init.sh

# Switch to non-root user before setting git config
USER gituser

# Set up git configuration (can be overridden with environment variables)
# This must be done as the gituser, not root
RUN git config --global user.name "Keybase Git User" && \
    git config --global user.email "keybase@localhost"

# Set up entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command
CMD ["bash"]


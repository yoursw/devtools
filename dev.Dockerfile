FROM debian:stable

# TODO: Extract to base image

# Base dependencies
RUN apt-get -y update && \
    apt-get -y install curl gnupg

# Base configuration

RUN groupadd -g 48 docker && \
	useradd -m dev -G docker

# Add Docker repo
RUN apt-get update && \
	 apt-get install ca-certificates curl && \
	 install -m 0755 -d /etc/apt/keyrings && \
	 curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
	 chmod a+r /etc/apt/keyrings/docker.asc && \
	 # Add the repository to Apt sources:
	 echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
	  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	 tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker CLI
RUN apt-get update && \
	apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# TODO: Determine whether there is a convenient/safe way to use the convenience script
# PERTINENT NOTE: This is NOT recommended in non-dev environments
# 		  however, we make a best effort to perform sanity checks.
RUN curl -fsSL https://get.docker.com -o get-docker.sh

# Add DDEV’s GPG key to your keyring
# REF:https://ddev.readthedocs.io/en/stable/users/install/ddev-installation/#manual
RUN sh -c 'echo ""' && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://pkg.ddev.com/apt/gpg.key | gpg --dearmor | tee /etc/apt/keyrings/ddev.gpg > /dev/null && \
    chmod a+r /etc/apt/keyrings/ddev.gpg && \
    sh -c 'echo ""' && \
    echo "deb [signed-by=/etc/apt/keyrings/ddev.gpg] https://pkg.ddev.com/apt/ * *" | tee /etc/apt/sources.list.d/ddev.list >/dev/null && \
    sh -c 'echo ""'

# Install drupal dev tool
RUN apt-get -y update && \ 
    apt-get install -y ddev && \
    mkcert -install # One-Time Initialization of Certs

USER dev

# Set working directory
# TODO: research why this isn't the default when using USER instruction
WORKDIR /home/dev

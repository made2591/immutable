FROM alpine:3.8

# Version of builders
ENV ANSIBLE_VERSION=2.5.5
ENV PACKER_VERSION=1.1.3
ENV TERRAFORM_VERSION=0.11.7
ENV TERRAGRUNT_VERSION=0.17.1

# Installing Ansible
RUN apk update && \
    apk add --update curl bash && \
    apk add --update ansible~=${ANSIBLE_VERSION}

# Installing Packer
RUN cd /usr/local/bin && \
    curl https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip -o packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /bin && \
    rm -f packer_${PACKER_VERSION}_linux_amd64.zip

# Installing Terraform
RUN cd /usr/local/bin && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Installing Terragrunt
RUN cd /usr/local/bin && \
    wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    mv terragrunt_linux_amd64 terragrunt && \
    chmod +x terragrunt

# Changing working directory
WORKDIR /work

# Setup bash as entrypoint
ENTRYPOINT ["/bin/bash"]
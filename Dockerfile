# Stage 1: Download and install tools for amd64
FROM ubuntu:22.04 AS amd64
WORKDIR /tmp
RUN apt-get update -y && \
    apt-get install -y unzip wget curl jq vim git python3 python3-pip

# Install terraform for amd64
RUN wget https://releases.hashicorp.com/terraform/1.4.4/terraform_1.4.4_linux_amd64.zip && \
    unzip terraform_1.4.4_linux_amd64.zip && \
    mv terraform /usr/local/bin/

# Install TFLINT for amd64
RUN curl -L "$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E -m 1 "https://.+?_linux_amd64.zip")" > tflint.zip && \
    unzip tflint.zip && \
    rm tflint.zip && \
    mv tflint /usr/bin/

# Install checkov for amd64
RUN pip3 install --no-cache-dir checkov

# Install TFSEC for amd64
RUN curl -L "$(curl -s https://api.github.com/repos/aquasecurity/tfsec/releases/latest | grep -o -E -m 1 "https://.+?tfsec-linux-amd64")" > tfsec && \
    chmod +x tfsec && \
    mv tfsec /usr/bin/

# Install OPA for amd64
RUN curl -L -o opa https://openpolicyagent.org/downloads/v0.52.0/opa_linux_amd64_static && \
    chmod 755 ./opa && \
    mv opa /usr/bin/

# Stage 2: Create the final multi-platform image
FROM --platform=linux/amd64,linux/arm64 ubuntu:22.04

# Copy tools from the amd64 stage
COPY --from=amd64 /usr/local/bin/terraform /usr/local/bin/
COPY --from=amd64 /usr/bin/tflint /usr/bin/
COPY --from=amd64 /usr/bin/checkov /usr/bin/
COPY --from=amd64 /usr/bin/tfsec /usr/bin/
COPY --from=amd64 /usr/bin/opa /usr/bin/

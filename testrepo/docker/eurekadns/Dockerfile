FROM jenkins/jenkins:lts
EXPOSE 8080 50000


USER root

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.10.3/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

#Install Azure CLI
RUN curl https://azurecliprod.blob.core.windows.net/release-2-0-25/debian_stretch_azure-cli_2.0.25-1_all.deb -o debian_stretch_azure-cli_2.0.25-1_all.deb && \
        dpkg -i debian_stretch_azure-cli_2.0.25-1_all.deb

# Install jq
ENV JQ_VERSION='1.5'

RUN wget --no-check-certificate https://raw.githubusercontent.com/stedolan/jq/master/sig/jq-release.key -O /tmp/jq-release.key && \
    wget --no-check-certificate https://raw.githubusercontent.com/stedolan/jq/master/sig/v${JQ_VERSION}/jq-linux64.asc -O /tmp/jq-linux64.asc && \
    wget --no-check-certificate https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -O /tmp/jq-linux64 && \
    gpg --import /tmp/jq-release.key && \
    gpg --verify /tmp/jq-linux64.asc /tmp/jq-linux64 && \
    cp /tmp/jq-linux64 /usr/bin/jq && \
    chmod +x /usr/bin/jq && \
    rm -f /tmp/jq-release.key && \
    rm -f /tmp/jq-linux64.asc && \
    rm -f /tmp/jq-linux64

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
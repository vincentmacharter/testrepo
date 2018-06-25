FROM jenkins/jenkins:lts
EXPOSE 8080 50000


USER root

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/1.10.3/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]

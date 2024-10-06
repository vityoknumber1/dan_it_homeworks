FROM jenkins/inbound-agent:latest

USER root

RUN apt-get update && apt-get install -y lsb-release

RUN usermod -u 1001 jenkins && groupmod -g 1001 jenkins

RUN groupadd -g 986 docker && usermod -aG docker jenkins

USER jenkins
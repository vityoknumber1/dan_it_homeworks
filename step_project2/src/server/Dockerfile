FROM jenkins/jenkins:2.462.2-jdk17

USER root

RUN apt-get update && apt-get install -y lsb-release

RUN usermod -u 1001 jenkins && groupmod -g 1001 jenkins

USER jenkins
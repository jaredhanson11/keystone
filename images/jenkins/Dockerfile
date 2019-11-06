FROM docker

WORKDIR /code/
COPY . /code/

ENV JENKINS_IMG "jenkins/jenkins:lts"
ENV JENKINS_DATA "~/.jenkins-data/"
ENV PORT 8080

RUN ["chmod", "+x", "docker-entrypoint.sh"]
CMD [ "sh", "./docker-entrypoint.sh" ]
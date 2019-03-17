# arch-jenkins-docker-jnlp-slave-dkp

This is a docker image that can be used as a slave in combination
with Jenkins and the yet-another-docker plugin which allows to
provision docker containers for Jenkins.

In addition, it comes with devkitpro packages and is used by buildservnx as of bsnx5.

## Setup
1. Run ``docker pull aveao/arch-jenkins-docker-jnlp-slave-dkp`` on your host
(this might also be done automatically by yet-another-docker plugin).
2. Make sure JNLP4 is enabled in you're Jenkins global security settings and
make sure that the port is reachable from you're docker host.
3. Go into you're Jenkins system settings and create a new **Yet Another Docker**
cloud. Set nbars/arch-jenkins-docker-jnlp-slave:latest as **Docker Image Name**.
Choose as **Launch method** the Docker JNLP launcher and set the **Linux User**
to jenkins.
5. Do not forget to assign a label to the cloud instance.
4. Create a new project and assign it to the container by setting
the previously configured label.

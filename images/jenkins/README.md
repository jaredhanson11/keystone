# Jenkins
A container that will startup a jenkins instance. You should run this contiainer with
`-v /var/run/docker.sock:/var/run/docker.sock` specified so that it connects to the docker
daemon running on the host machine.
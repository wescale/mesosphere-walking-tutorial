# Mesosphere walking tutorial

This is an Ansible automation following the tutorial of Mesosphere to setup an Apache Mesos cluster. At the end, 
you'll get a functional Mesos cluster with a Docker image of nginx deployed on it.

## Getting started

* In ```variables.yml```, think about changing the ```aws.idempotency_id``` value BEFORE EACH fresh setup of AWS infrastructure.
* Before launching any script of this repository, set these environment variables:
    * EC2_REGION=...
    * AWS_ACCESS_KEY=...
    * AWS_SECRET_KEY=...

## Walking steps

* ```1-spawn_aws_infra.sh``` : Spawns infrastructure on AWS and generates a host inventory usable by Ansible 
for next steps
* ```2-mesosphere_setup.sh``` : Installs and configure all servers.
* ```3-slave_restart.sh``` : Reboots slaves, so the new Docker-compliant kernel installed, will work.
* ```4-start_nginx_docker.sh``` : Send a HTTP POST to marathon, to get nginx running.

## Hack in peace !
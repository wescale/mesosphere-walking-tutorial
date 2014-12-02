# DIY Cluster: The walking tutorial

_Some times ago, I encountered the [Apache Mesos Project](http://mesos.apache.org/) on my road
through CodeWorld, And I fell in love. Shortly after, I met [Mesosphere](http://mesosphere.com/), its twin sister. She knew a lot of things about Mesos and I started to read every Mesosphere blog posts to know better how to seduce Mesos..._

So long for the literary style. I’m a fan of Mesos and also a fan of [Ansible](http://www.ansible.com/), so instead of going step by step through the Mesosphere tutorials, I began to write Ansible playbooks to automate and run them.

Lacking of physical hardware, I chose Amazon Web Services as my laboratory. Now it’s time to share some feedbacks about this trip through the mesosphere.

## Why

First things firt, if you don’t already know it, Ansible is an automation tool for managing app deployment, configuration management and continuous delivery. It has a great learning curve and a ton of module to do a lot of thing, from driving cloud providers to templating files or checking that system services are enabled on a target host.

Ansible has a wide community of playbooks contributors, Mesosphere knows its lesson and lead me to the AnsibleShipyard. But it isn’t DIY if you only take contribution and run. Also, I don’t really like the **role** advised by Ansible as best practices.

So I packed my own playbooks to grow in Mesos mastering and adapt my automatisation along the road. It might be less following **best practices**, but I think it ends with a more comprehensive version of a mesosphere cluster setup. Let’s see together how you can reproduce the steps to make you own.


## How

All this has been built and run on OS X but should run without any
problem under Linux. You’ll need :

* a local installation of Ansible
* an AWS account, with rights to create security groups and spawn
instances
* the name of the AWS region you want to target (for example, mine was:
eu-west-1)
* a local clone of this Github repository:
https://github.com/WeScale/mesosphere-walking-tutorial

export you **AWS_ACCESS_KEY**, **AWS_SECRET_KEY** and **EC2_REGION** in your terminal and cd into the repo to dive in. Then if you want to rush, just launch the numeroted shell script in order. Let’s see together in
detail their behavior.

### ./1-spawn_aws_infra.sh

**Disclaimer:** in the variables.yml file, change the `aws.idempotency_id` value before each setup you want to deploy on AWS. That value is used by Ansible and AWS to ensure that multiple run of the playbook will not results in systematically spawing new instances.

As it is built, the playbook will check the presence of a local ssh key named in **variables.yml**, and if it does not exist, generate it before registering it with AWS.

That step will create one security group for Mesos master nodes and one for the slave nodes, spawn master and slave node according to their description in variables.yml, and generate an Ansible formatted host inventory to be used by next steps.

The advised values of 3 master nodes and quorum of 2 are not efficient in AWS, where race conditions in instance spawing may occur. The behavior of a master node if all can’t get to elect a master is to simply shutdown… That can get frustrating when happening for the first time. A 5 master nodes with a quorum of 3 seems to be a good deal and to be a reliable setup. That are my default values, but you can change the count values in variables.yml if you like.

### ./2-mesosphere_setup.sh

Where the magic happens… This step will configure Zookeeper, Mesos Master and Marathon on every master node, listed in the host inventory under the upper_mesosphere group. Also, it will installer Mesos and change the kernel of the AWS slave instances to enable Docker-ability on them. After this step, if you point a browser to any public DNS of a master node:

* on port 8080 you’ll get to Marathon web interface
* on port 5050 you’ll get ot the mesos dashboard

Every slave node is equipped with a HAProxy instance that regenerates
its configuration every minute by crawling Marathon.

### ./3-slave_restart.sh

Previous step has changed kernel on slave so we need to reboot them. Thrilling, I know. Still, take a minute to look at the content of this script, it's a good and simple example of an arbitrary task, run on a subest of hosts. That can **very** useful.

### ./4-start_nginx_docker.sh $SOME_MASTER_NODE

That script encapsulates a curl POST on Marathon’s API on the node given as command line parameter. That will spawn a basic nginx docker on your fresh cluster setup. You can follow its deployment state on Marathon or Mesos web interfaces.

Once it gets deployed, wait for one minute and your HAProxy configuration will be reloaded, so you can access the nginx by any of the slaves.

## What (to do now?)

This walking tutorial is for exploratory process. So if you reached this point, now go and dissect my playbooks, enhance them and build your own Yourself-flavoured Mesos Cluster. Some thoughts about what could be ameliorated.

### Service Discovery

The service discovery method described in Mesosphere tutorials and demonstrated here is only port-based. You need to ensure that your Marathon deployment are not overlapping from servicePort to servicePort, so the HAProxy generated configuration stays consistent. Thus, one port, one service.

I think that is a too little choice and that a Dnsmasq configuration generator, based on the haproxy-marathon-bridge, could be a really cool enhancement. That would allow to add an axis to the service map of the cluster.

### Cluster-wide support services

Now we have a mesos cluster, that could be a great idea to stuff it with services every business app could need. That could be:

* a distributed file system
* log centralization solution
* system-level monitoring of slave nodes
* a coffee machine

## Credits

Great thank to the Mesosphere teams for their great tutorials, and to Ansible teams for their awesome tools. Sincerly (I wasn't paid for this writing ;-). It killed a bunch of my sleep hours but I had a great time and will surely play with these toys for a while.

Have fun and share code.

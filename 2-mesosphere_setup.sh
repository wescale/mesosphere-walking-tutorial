#!/bin/sh

export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook playbooks/mesosphere_setup.yml -i ec2_inventory

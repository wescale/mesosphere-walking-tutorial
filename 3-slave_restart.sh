#!/bin/sh

ansible lower_mesosphere -i ec2_inventory -m shell -a reboot -u admin -s

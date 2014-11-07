# WeScale Mesos

* Régler les paramètres dans ```playbooks/variables```, penser à changer l'idempotency_id AVANT chaque nouveau déploiement d'infra.
* ```ansible-playbook -i local playbooks/seed-ec2-infra.yml``` : spawn l'infra sur ec2
    * il faut avoir les bonnes variables d'environnement settées :
        * EC2_REGION=eu-west-1
        * AWS_ACCESS_KEY=...
        * AWS_SECRET_KEY=...

une fois l'infra spawnée, le playbook génère un host inventory dans ```playbooks/ec2_inventory```
Il faut le sortir, et le ramener à la racine du projet pour ensuite :

```ansible-playbook -i ec2_inventory playbooks/mesosphere-paas.yml```

Toute cette tambouille pour obtenir : 

* 5 mesos master, colocalisé avec des noeud zookeeper 
* 3 slaves, docker-ready 
* Marathon

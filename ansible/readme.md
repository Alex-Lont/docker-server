# Home Ansible

tags must be call via cli

## Test config for Ansible facts

```bash
ansible-playbook playbooks/ping.yaml -u ubuntu

ansible-playbook playbooks/test.yaml
```

## Create User

```bash
ansible-playbook playbooks/setup.yaml -u root
```

## Install defaults and Config

```bash
ansible-playbook playbooks/init.yaml --ask-become-pass -t restart,vm,docker,DNS,torrent,plex,nextcloud  
```

## General Updatre Playbooks

```bash
ansible-playbook playbooks/ufw.yaml -t DNS,torrent,plex,nextcloud

ansible-playbook playbooks/updates.yaml -t restart
```

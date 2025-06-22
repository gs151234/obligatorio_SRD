#!/bin/bash

echo "[1/2] Ejecutando bootstrap con puerto default..."
ansible-playbook playbooks/bootstrap.yml -i inventory/hosts.ini \
  -u sysadmin --ask-pass --ask-become-pass

echo "[2/2] Esperando 10s para reinicio SSH..."
sleep 10

echo "[2/2] Ejecutando playhard con ansible y puerto 61189..."
ansible-playbook playbooks/playhard.yml -i inventory/hosts.ini \
  -u ansible --private-key ~/.ssh/ansible -e ansible_port=61189 -vvv

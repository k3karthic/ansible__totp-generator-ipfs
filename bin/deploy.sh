#!/usr/bin/env bash

ansible -i inventory/oracle.oci.yml all -a "/home/{{ ansible_ssh_user }}/bin/publish_totp_ipfs.sh"

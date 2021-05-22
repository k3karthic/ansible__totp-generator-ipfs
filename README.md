# Ansible - Deploy TOTP Generator to IPFS

The Ansible playbook in this repository creates a bash script which can deploy [totp-generator-web](https://github.com/k3karthic/totp-generator-web) to IPFS and updates the CID in IPNS using a given key.

The playbook assumes the instance runs in Oracle Cloud using the terraform script below,
* [https://github.com/k3karthic/terraform__oci-instance-2](https://github.com/k3karthic/terraform__oci-instance-2).

The repository also includes `bin/deploy.sh` that executes `publish_totp_ipfs.sh` on the instance using an Ansible ad-hoc task.

## Requirements

Install the following Ansible modules before running the playbook,
```
pip install oci
ansible-galaxy collection install oracle.oci
```

## Dynamic Inventory

This playbook uses the Oracle [Ansible Inventory Plugin](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/ansibleinventoryintro.htm) to populate public Ubuntu instances dynamically.

Public instances are assumed to have a freeform tag `ipfs_service: yes`.

## Playbook Configuration

1. Modify `inventory/oracle.oci.yml`
    1. specify the region where you have deployed your server on Oracle Cloud.
    1. Configure the authentication as per the [Oracle Guide](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/sdkconfig.htm#SDK_and_CLI_Configuration_File).
1. Set username and ssh authentication in `inventory/group_vars/`.

### IPNS Initialization

The IPNS URL is generated based on a keypair. Follow the instructions below to create a keypair for the deployment.

Create a key using the following command and note the ID in the result,
```
ipfs key gen <name>
```

Export the key using the following command,
```
ipfs key export <name>
```

1. Save the ID and name in `inventory/group_vars/tag_ipfs_service=yes.yml` based on the sample `inventory/group_vars/tag_ipfs_service=yes.yml.sample`.
1. Save the exported key in the `files` directory.

## Deployment

Run the playbook using the following command,
```
./bin/apply.sh
```

## Encryption

Sensitive files like the IPFS key and SSH private keys are encrypted before being stored in the repository.

You must add the unencrypted file paths to `.gitignore`.

Use the following command to decrypt the files after cloning the repository,

```
./bin/decrypt.sh
```

Use the following command after running terraform to update the encrypted files,

```
./bin/encrypt.sh <gpg key id>
```

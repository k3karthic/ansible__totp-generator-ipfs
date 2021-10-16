# Ansible - Deploy TOTP Generator to IPFS

This playbook creates a bash script which can,
* Deploy [totp.cf.maverickgeek.xyz](https://totp.cf.maverickgeek.xyz/) to [InterPlanetary File System (IPFS)](https://ipfs.io/).
* Update the [Content Identifier (CID)](https://docs.ipfs.io/concepts/content-addressing/) in [InterPlanetary Name System (IPNS)](https://docs.ipfs.io/concepts/ipns/).

Demo,
* CloudFlare: [https://cloudflare-ipfs.com/ipns/k51qzi5uqu5dii8e5k7q6qpbz91or4gjluu2egnrtm6lkhb15lwok3a0ylxqf9](https://cloudflare-ipfs.com/ipns/k51qzi5uqu5dii8e5k7q6qpbz91or4gjluu2egnrtm6lkhb15lwok3a0ylxqf9)
* Pinata: [https://gateway.pinata.cloud/ipns/k51qzi5uqu5dii8e5k7q6qpbz91or4gjluu2egnrtm6lkhb15lwok3a0ylxqf9](https://gateway.pinata.cloud/ipns/k51qzi5uqu5dii8e5k7q6qpbz91or4gjluu2egnrtm6lkhb15lwok3a0ylxqf9)
* dweb.link: [https://dweb.link/ipns/k51qzi5uqu5dii8e5k7q6qpbz91or4gjluu2egnrtm6lkhb15lwok3a0ylxqf9](https://dweb.link/ipns/k51qzi5uqu5dii8e5k7q6qpbz91or4gjluu2egnrtm6lkhb15lwok3a0ylxqf9)

**Assumption:** The instance runs in Oracle Cloud using the terraform script below,
* [https://github.com/k3karthic/terraform__oci-instance-2](https://github.com/k3karthic/terraform__oci-instance-2).

`bin/deploy.sh` uses an Ansible ad-hoc task to run `publish_totp_ipfs.sh` on the instance.

## Code Mirrors

* GitHub: [github.com/k3karthic/ansible__totp-generator-ipfs](https://github.com/k3karthic/ansible__totp-generator-ipfs)
* Codeberg: [codeberg.org/k3karthic/ansible__totp-generator-ipfs](https://codeberg.org/k3karthic/ansible__totp-generator-ipfs)

## Dynamic Inventory

The Oracle [Ansible Inventory Plugin](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/ansibleinventoryintro.htm) dynamically populates public Ubuntu instances.

All target instances must have the freeform tag `ipfs_service: yes`.

## Requirements

Install the following Ansible modules and plugins before running the playbook.
```
pip install oci
ansible-galaxy collection install oracle.oci
```

## Playbook Configuration

1. Update `inventory/oracle.oci.yml`,
    1. specify the region where you have deployed your server on Oracle Cloud.
    1. Configure the authentication as per the [Oracle Guide](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/sdkconfig.htm#SDK_and_CLI_Configuration_File).
1. Set username and SSH authentication in `inventory/group_vars/`.

### IPNS Initialization

IPNS derives the public URL from a keypair. Follow the instructions below to create a keypair.

Create a key using the following command and note the ID in the result,
```
ipfs key gen <name>
```

Export the key using the following command,
```
ipfs key export <name>
```

1. Save the ID and name in `inventory/group_vars/tag_ipfs_service=yes.yml`. Use `inventory/group_vars/tag_ipfs_service=yes.yml.sample` as a reference.
1. Save the exported key in the `files` directory.

## Deployment

Run the playbook using the following command,
```
./bin/apply.sh
```

## Encryption

Encrypt sensitive files (IPFS key, SSH private keys) before saving them. `.gitignore` must contain the unencrypted file paths.

Use the following command to decrypt the files after cloning the repository.

```
./bin/decrypt.sh
```

Use the following command after running terraform to update the encrypted files.

```
./bin/encrypt.sh <gpg key id>
```

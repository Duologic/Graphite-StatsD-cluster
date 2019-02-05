Terraform playbooks for Unleashed
=================================

This project is commissioned by Unleashed NV, these are the Terraform scripts that are used during the development to reflect a more production-like environment.

TODO:
- Format and mount volumes automatically with Terraform (or Ansible if Terraform does not suffice)

Requirements
------------

- [Ansible](https://docs.ansible.com/)
- [Terraform](https://www.terraform.io/) (only required if you want to deploy it on AWS)
- this git repo + submodules

I've been working from a macOS machine, here are the installation instructions with [Homebrew](https://brew.sh/):

    brew install ansible
    brew install terraform

    git clone git@github.com:Duologic/Graphite-StatsD-cluster.git
    git submode update --init

For Terraform/AWS configuration, get an IAM user with at EC2 access and put the credentials here `$HOME/.aws/credentials`:

    [unleashed-staging]
    aws_access_key_id=XXX
    aws_secret_access_key=XXX

Let's go
--------

In `group_vars/` you'll find ansible-vault encrypted configuration, you might want to replace those as you can't read them:

    # ansible-vault view group_vars/graphite-frontend.yml
    postgresql_admin_password: 'XXX'
    grafana_db_password: 'XXX'
    grafana_admin_password: 'XXX'
    grafana_cloudwatch_accessKey: 'XXX'
    grafana_cloudwatch_secretKey: 'XXX'

    # ansible-vault view group_vars/graphite.yml
    graphite_secret_key: 'XXX'
    graphite_admin_password: 'XXX'

You should now have an environment that would allow you to spin up a Graphite cluster:

    cd tf/
    terraform init
    terraform apply
    cd -
    # The volumes on the graphite-db nodes might not be formatted and mounted, see TODO.
    ansible-playbook -i tf/terraform_inventory {carbon,statsd,graphite,grafana}.yml

Surf to http://<graphite-frontend-ip>:3000/

This should be make available behind a proxy with SSL.

Important files
---------------

- ./ansible.cfg: the inventory file is referenced here, I prefer my own SSH config so I override the defaults here
- ./tf/variables.cfg: the Terraform configuration options for the module: zones, IPs, keys, ...

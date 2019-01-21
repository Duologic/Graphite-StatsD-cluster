A Graphite/StatsD setup with Vagrant and Ansible
================================================

This repository bundles a bunch of Ansible roles to provide a Graphite cluster with StatsD and Carbon-relay-ng.

This project is commissioned by Unleashed NV, you'll also find Terraform scripts in ./tf/ that are used during the development to reflect a more production-like environment.

TODO:
- Add Grafana frontend
- Format and mount volumes automatically with Terraform (or Ansible if Terraform does not suffice)
- Make volumes persistent (do not remove them on `terraform destroy`)
- Finish Terraform configuration
- Expand documentation

Requirements
------------

- Vagrant (tested with VirtualBox)
- Ansible (tested with Python 3 virtualenv)
- this git repo + submodules

I've been working from a macOS machine, here are the installation instructions for that:

    brew cask install vagrant
    brew cask install virtualbox

    brew install python
    python3 -m venv .venv
    source .venv/bin/activate
    pip install ansible

    git clone git@github.com:Duologic/vagrant-ansible-graphite-statsd.git
    git submode update --init

Let's go
--------

You should now have an environment that would allow you to spin up a Graphite cluster:

    vagrant up

Important files
---------------

- Vagrantfile: glues the VMs together and creates an Ansible inventory
- ./ansible.cfg: the inventory file is referenced here, I prefer my own SSH config so I override the defaults here too

License
-------

MIT

Author Information
------------------

Jeroen Op 't Eynde, jeroen@simplistic.be

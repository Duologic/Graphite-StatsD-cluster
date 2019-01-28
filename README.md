A Graphite/StatsD cluster
=========================

This repository bundles a bunch of Ansible roles to provide a Graphite cluster with Statsdaemon and Carbon-relay-ng.

For Unleashed NV, I'm developing a set of Terraform playbooks with its own [documentation](tf/README.md).

Requirements
------------

- [Ansible](https://docs.ansible.com/)
- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- this git repo + submodules

I've been working from a macOS machine, here are the installation instructions with [Homebrew](https://brew.sh/):

    brew install ansible
    brew cask install virtualbox
    brew cask install vagrant

    git clone git@github.com:Duologic/vagrant-ansible-graphite-statsd.git
    git submode update --init

Let's go
--------

In `vars/` you'll find ansible-vault encrypted configuration, you might want to replace those as you can't read them:

    # cat vars/grafana_secrets.yml
    grafana_admin_password: 'XXX'
    grafana_cloudwatch_accessKey: 'XXX'
    grafana_cloudwatch_secretKey: 'XXX'

    # cat vars/graphite_secrets.yml
    graphite_secret_key: 'XXX'
    graphite_admin_password: 'XXX'

You should now have an environment that would allow you to spin up a Graphite cluster:

    vagrant up

Surf to https://localhost:3000/

Important files
---------------

- ./ansible.cfg: the inventory file is referenced here, I prefer my own SSH config so I override the defaults here
- Vagrantfile: glues the VMs together and creates an Ansible inventory

License
-------

MIT

Author Information
------------------

Jeroen Op 't Eynde, jeroen@simplistic.be

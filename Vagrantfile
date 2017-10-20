# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
   config.vm.box = "centos/7"

   ansible_groups = {
       "graphite-storage" => ["graphite0-db", "graphite1-db"],
   }

    # StatsD node
    #config.vm.define "statsd" do |machine|
    #    machine.vm.hostname = "statsd"
    #    machine.vm.network "forwarded_port", guest: 8125, host: 8125, protocol: 'tcp'
    #    machine.vm.network "forwarded_port", guest: 8125, host: 8125, protocol: 'udp'
    #    machine.vm.network "private_network", ip: "192.168.34.9"
    #    machine.vm.provision :ansible do |ansible|
    #        ansible.groups = ansible_groups
    #        ansible.limit = "all"
    #        ansible.playbook = "statsd.yml"
    #        #ansible.extra_vars = ansible_extra_vars
    #    end
    #end

    # Carbon-relay node
    config.vm.define "carbon-relay" do |machine|
        machine.vm.hostname = "carbon-relay"
        machine.vm.network "forwarded_port", guest: 2003, host: 2003
        machine.vm.network "forwarded_port", guest: 2004, host: 2004
        machine.vm.network "private_network", ip: "192.168.34.9"
        machine.vm.provision :ansible do |ansible|
            ansible.groups = ansible_groups
            ansible.limit = "all"
            ansible.playbook = "carbon.yml"
            #ansible.extra_vars = ansible_extra_vars
        end
    end

    # Graphite DB node
    (0..1).each do |machine_id|
        config.vm.define "graphite#{machine_id}-db" do |machine|
            machine.vm.provider "virtualbox" do |v|
                v.memory = 1024
            end
            machine.vm.hostname = "graphite#{machine_id}-db"
            machine.vm.network "forwarded_port", guest: 3032, host: "303#{machine_id}"
            machine.vm.network "private_network", ip: "192.168.34.1#{machine_id}"
            if machine_id == 1
                machine.vm.provision :ansible do |ansible|
                    ansible.groups = ansible_groups
                    ansible.limit = "all"
                    ansible.playbook = "graphite.yml"
                    #ansible.extra_vars = ansible_extra_vars
                end
            end
        end
    end

    config.vm.provision "shell", inline: <<-SHELL
        yum install -y epel-release
        yum install -y htop vim telnet curl
    SHELL
end

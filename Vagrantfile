# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
   config.vm.box = "ubuntu/bionic64"

   ansible_groups = {
       "graphite-storage" => ["graphite-db0", "graphite-db1"],
       "monitor-relay" => ["monitor-relay1"],
       "monitor-relay:vars" => {
           "carbon_caches" => [
               '192.168.34.10',
               '192.168.34.11',
           ],
           "carbon_relay" => '192.168.34.9',
       },
   }

    # monitor-relay node
    config.vm.define "monitor-relay1" do |machine|
        machine.vm.hostname = "monitor-relay1"
        machine.vm.network "forwarded_port", guest: 8125, host: 8125, protocol: 'tcp'
        machine.vm.network "forwarded_port", guest: 8125, host: 8125, protocol: 'udp'
        machine.vm.network "forwarded_port", guest: 8126, host: 8126
        machine.vm.network "forwarded_port", guest: 8081, host: 8081
        machine.vm.network "forwarded_port", guest: 2003, host: 2003
        machine.vm.network "forwarded_port", guest: 2013, host: 2013
        machine.vm.network "forwarded_port", guest: 2004, host: 2004
        machine.vm.network "private_network", ip: "192.168.34.9"
        machine.vm.provision :ansible do |ansible|
            ansible.groups = ansible_groups
            ansible.limit = "all"
            ansible.playbook = "carbon.yml"
        end
        machine.vm.provision :ansible do |ansible|
            ansible.groups = ansible_groups
            ansible.limit = "all"
            ansible.playbook = "statsd.yml"
        end
    end

    # Graphite DB node
    (0..1).each do |machine_id|
        config.vm.define "graphite-db#{machine_id}" do |machine|
            machine.vm.provider "virtualbox" do |v|
                v.memory = 1024
            end
            machine.vm.hostname = "graphite-db#{machine_id}"
            machine.vm.network "forwarded_port", guest: 3032, host: "303#{machine_id}"
            machine.vm.network "private_network", ip: "192.168.34.1#{machine_id}"
            if machine_id == 1
                machine.vm.provision :ansible do |ansible|
                    ansible.groups = ansible_groups
                    ansible.limit = "all"
                    ansible.playbook = "graphite.yml"
                end
            end
        end
    end

    config.vm.provision "shell", inline: <<-SHELL
        sudo apt-get install -y htop vim telnet curl python
    SHELL
end

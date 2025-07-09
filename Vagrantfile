# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  # Kubernetes Master Server
  config.vm.define "kmaster" do |node|
  
    node.vm.box               = "gutehall/ubuntu24-04"
    node.vm.box_check_update  = false
    #node.vm.hostname          = "kmaster.example.com"

    node.vm.network "private_network", ip: "192.168.59.100"

  
    node.vm.provider :virtualbox do |v|
      v.name    = "master"
      v.memory  = 2048
      v.cpus    =  2
    end
  
    node.vm.provider :libvirt do |v|
      v.memory  = 2048
      v.nested  = true
      v.cpus    = 2
    end
  
  end


  # Kubernetes Worker Nodes
  NodeCount = 2

  (1..NodeCount).each do |i|

    config.vm.define "kworker#{i}" do |node|

      node.vm.box               = "gutehall/ubuntu24-04"
      node.vm.box_check_update  = false
      #node.vm.hostname          = "kworker#{i}.example.com"

      node.vm.network "private_network", ip: "192.168.59.10#{i}"

      node.vm.provider :virtualbox do |v|
        v.name    = "worker#{i}"
        v.memory  = 2048
        v.cpus    = 2
      end

      node.vm.provider :libvirt do |v|
        v.memory  = 2048
        v.nested  = true
        v.cpus    = 2
      end

    end

  end

end

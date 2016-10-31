# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure('2') do |config|
    config.vm.define 'vagrant-win-10'
    config.vm.box = 'windows_10'
    config.vm.communicator = 'winrm'

    # Admin user name and password
    config.winrm.username = 'vagrant'
    config.winrm.password = 'vagrant'

    config.vm.guest = :windows
    config.windows.halt_timeout = 15

    config.vm.network :forwarded_port, guest: 3389, host: 33389, id: 'rdp', auto_correct: true
    
    config.vm.provider :virtualbox do |v, override|
        v.gui = true
        v.customize ['modifyvm', :id, '--memory', 4096]
        v.customize ['modifyvm', :id, '--cpus', 2]
        v.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 1, '--device', 0, '--type', 'dvddrive', '--medium', 'iso/configdrive.iso']
        v.customize ['setextradata', 'global', 'GUI/SuppressMessages', 'all' ]
    end
  end

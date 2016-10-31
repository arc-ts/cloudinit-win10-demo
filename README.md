# Cloudinit Windows Demo

This project serves as a proof-of-concept demo using [cloudbase-init](https://cloudbase.it/cloudbase-init/) [configdrive](https://cloudbase-init.readthedocs.io/en/latest/services.html#openstack-configuration-drive) datasource with Windows 10.

It uses packer to first build a suitable vagrant virtualbox image. Then uses the supplied [iso generation script](create_iso.sh) and [Vagrantfile](Vagrantfile) to execute the `user_data` provisioner within the Windows guest upon startup.


## Usage
1. Install [packer](https://www.packer.io/downloads.html), [vagrant](https://www.vagrantup.com/downloads.html), and [virtualbox](https://www.virtualbox.org/wiki/Downloads).
2. Clone this repository and set it to your working directory.
3. Use Packer to build the vagrant image with this command: `packer build windows_10.json`
4. Import the newly generated vagrant box with the command `vagrant box add --name windows_10 windows_10.box`
5. Make any desired changes to the `user_data` portion of cloudinit by modifying the content in `cloud_config/openstack/latest/user_data`. For the purposes of this demo, it is by default only configured to set the hostname to `usertest`.
6. Generate the configdrive iso by executing the `create_iso.sh` script.
7. Start the VM with the command `vagrant up`. **NOTE:** It will restart. This is done after executing the cloud-init configuration.

The VM should be accessible either through the virtualbox gui, or may be rdp'ed directly to by executing the `vagrant rdp` command. At this stage it should be configured per the cloudinit configuration data. A log of both the build process and cloudinit configuration can be found in the directory: `C:\Build_Logs`.

## License
[MIT](LICENSE)
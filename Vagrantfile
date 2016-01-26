# If you change the base network you will need to update the hosts script in
# the scripts folder
$base_network='192.168.11'

$slave_gui=false
$slave_memory='1024'
$slave_cpus='1'
$slave_num=3

$master_gui=false
$master_memory='1024'
$master_cpus='1'

# If you edit the number of masters, it will need to be reflected in the 
# environments/production/manifests/mesosmaster.pp file
$master_num=3

Vagrant.configure(2) do |config|

# Global Configuration
  config.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"


  config.r10k.puppet_dir = "environments/production"
  config.r10k.puppetfile_path = "environments/production/Puppetfile"
  config.r10k.module_path = "environments/production/modules"

# Create Masters
  (1..$master_num).each do |i|
    config.vm.define vm_name = "master%02d" % i do |master_config|
      master_config.vm.hostname = vm_name

      ["vmware_fusion", "vmware_workstation"].each do |vmware|
        master_config.vm.provider vmware do |v|
          v.gui = $master_gui
          v.vmx['memsize'] = $master_memory
          v.vmx['numvcpus'] = $master_cpus
        end
      end

      master_config.vm.provider :virtualbox do |vb|
        vb.gui = $master_gui
        vb.memory = $master_memory
        vb.cpus = $master_cpus
      end

      ip = $base_network+".#{i}"
      master_config.vm.network :private_network, ip: ip

      master_config.vm.provision "puppet" do |puppet|
        puppet.environment = "production"
        puppet.environment_path = "environments"
        puppet.manifests_path = "./environments/production/manifests"
        puppet.manifest_file = "mesosmaster.pp"
      end

    end
  end # End Masters' Configuration
  
# Create Slaves
  (1..$slave_num).each do |i|
    config.vm.define vm_name = "slave%02d" % i do |slave_config|
      slave_config.vm.hostname = vm_name

      ["vmware_fusion", "vmware_workstation"].each do |vmware|
        slave_config.vm.provider vmware do |v|
          v.gui = $slave_gui
          v.vmx['memsize'] = $slave_memory
          v.vmx['numvcpus'] = $slave_cpus
        end
      end

      slave_config.vm.provider :virtualbox do |vb|
        vb.gui = $slave_gui
        vb.memory = $slave_memory
        vb.cpus = $slave_cpus
      end

      ip = $base_network+".#{i+100}"
      slave_config.vm.network :private_network, ip: ip

      slave_config.vm.provision "puppet" do |puppet|
        puppet.environment = "production"
        puppet.environment_path = "environments"
        puppet.manifests_path = "./environments/production/manifests"
        puppet.manifest_file = "mesosslave.pp"
      end

    end
  end # End Slaves' Configuration
end

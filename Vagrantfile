# If you change the base network you will need to update the hosts script in
# the scripts folder
$base_network='192.168.11'

$agent_gui=false
$agent_memory='1024'
$agent_cpus='1'
$agent_num=3

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

# Create masters
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
  end # End masters' Configuration
  
# Create Agents
  (1..$agent_num).each do |i|
    config.vm.define vm_name = "agent%02d" % i do |agent_config|
      agent_config.vm.hostname = vm_name

      ["vmware_fusion", "vmware_workstation"].each do |vmware|
        agent_config.vm.provider vmware do |v|
          v.gui = $agent_gui
          v.vmx['memsize'] = $agent_memory
          v.vmx['numvcpus'] = $agent_cpus
        end
      end

      agent_config.vm.provider :virtualbox do |vb|
        vb.gui = $agent_gui
        vb.memory = $agent_memory
        vb.cpus = $agent_cpus
      end

      ip = $base_network+".#{i+100}"
      agent_config.vm.network :private_network, ip: ip

      agent_config.vm.provision "puppet" do |puppet|
        puppet.environment = "production"
        puppet.environment_path = "environments"
        puppet.manifests_path = "./environments/production/manifests"
        puppet.manifest_file = "mesosslave.pp"
      end

    end
  end # End Agents' Configuration
end

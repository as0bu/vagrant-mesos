# ubuntu14-mesos

## Description
This Vagrant environment sets up a Mesos Cluster

## What do I need?
This is working with the current software and versions
 - vagrant (version 1.7.4)
 - vagrant-r10k (0.4.1)
 - vagrant-cachier (optional)
   - Speeds up the deployment process
 - virtualbox (version 5.0.6)

## How to Start Environment
```
git clone https://github.com/kovarus/vagrant-mesos.git
cd vagrant-mesos
vagrant up
navigate to http://192.168.11.11:5050 for the Mesos UI
navigate to http://192.168.11.11:8080 for the Marathon UI
navigate to http://192.168.11.11:4400 for the Chronos UI
```

## How to Use the Environment
The following will test the cluster
```
vagrant ssh master01
mesos-execute --master=$MASTER --name='cluster-test' --command='sleep 40'
# hit ctrl-z
bg
# check for process in the Mesos UI or
mesos ps
```

## Issues
 - Sometimes when the environment first comes up the following error message appears on
   the master leading the cluster
   ```
   Failed to shutdown socket with fd <number>: Transport endpoint is not connected
   ```
   To resolve this log into the leading master and restart the _mesos-master_
   process.
   
## To Do
 - Add Mesos DNS

## Notes

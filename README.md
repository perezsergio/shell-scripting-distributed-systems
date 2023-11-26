# SHELL SCRIPTING IN DISTRIBUTED SYSTEMS

These are the scripts that I wrote for the second part of the course "Linux Shell Scripting Projects", https://www.udemy.com/course/linux-shell-scripting-projects.This part focuses on shell scripting for distributed systems, i.e. clusters with multiple servers.

I used Vagrant virtual machines to simulate a cluster. If you want to set up your own cluster of vagrant VMs you can do so by following the next steps.

First, if you don't have vagrant installed, you should install it, of course.

```console
sudo apt-get install vagrant
```

If you are not using apt, substitute it by your preferred package manager.

Next, you should create a directory and initialize a vagrant project.

```console
vagrant box add jasonc/centos7
mkdir <my-dir>
cd <my-dir>
vagrant init jasonc/centos7
```

The previous step should have created the file `Vagrantfile`. Edit the file show that it looks identical to the `Vagrantfile` of this repo.

Finally,

```console
vagrant up
vagrant ssh [admin01]
```

You should remember to stop the VMs when you are done

```console
vagrant halt
```

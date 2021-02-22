[![Actions Status - Master](https://github.com/juju4/ansible-polarproxy/workflows/AnsibleCI/badge.svg)](https://github.com/juju4/ansible-polarproxy/actions?query=branch%3Amaster)
[![Actions Status - Devel](https://github.com/juju4/ansible-polarproxy/workflows/AnsibleCI/badge.svg?branch=devel)](https://github.com/juju4/ansible-polarproxy/actions?query=branch%3Adevel)


# PolarProxy install

This role will install [Netresec PolarProxy](https://www.netresec.com/?page=PolarProxy)

# Requirements & Dependencies

### Ansible
It was tested on the following versions:
 * 2.8
 * 2.10

### Operating systems

Tested with molecule on Ubuntu 16.04, 18.04, 20.04 and Centos 7-8

## Example Playbook

Just include this role in your list.
For example

```
- host: all
  roles:
    - juju4.polarproxy
```

## Continuous integration

This role has a travis config leveraging molecule for testing, also kitchen with docker and vagrant

Once you ensured all necessary roles are present, You can test with:
```
$ pip install molecule docker
$ molecule test
$ molecule --debug test
$ MOLECULE_DISTRO=ubuntu:16.04 molecule test --destroy=never
```

```
$ gem install kitchen-ansible kitchen-docker kitchen-sync
$ cd /path/to/roles/juju4.polarproxy
$ kitchen verify
$ kitchen login
$ KITCHEN_YAML=".kitchen.docker.yml" kitchen verify
```
or
```
$ cd /path/to/roles/juju4.polarproxy/test/vagrant
$ vagrant up
$ vagrant ssh
```

## Troubleshooting & Known issues

* Use as explicit proxy
```
Oct 01 00:04:31 testhostname PolarProxy[49741]: [10443] n.n.n.n -> N/A System.IO.IOException : The handshake failed due to an unexpected packet format.
Oct 01 00:04:31 testhostname PolarProxy[49741]: [10443] n.n.n.n -> N/A Internal and/or external SSL session did not authenticate successfully
Oct 10 00:07:02 testcentral PolarProxy[49741]: [10443] n.n.n.n -> N/A System.IO.IOException : Authentication failed because the remote party has closed the transport stream.
Oct 10 00:07:02 testcentral PolarProxy[49741]: [10443] n.n.n.n -> N/A Internal and/or external SSL session did not authenticate successfully
```
PolarProxy works only as Transparent Proxy and requires firewall redirection. It can't be explicit through browser.

## License

BSD 2-clause

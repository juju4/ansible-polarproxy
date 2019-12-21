#!/bin/sh
## one script to be used by travis, jenkins, packer...

umask 022

if [ $# != 0 ]; then
rolesdir=$1
else
rolesdir=$(dirname $0)/..
fi

#[ ! -d $rolesdir/juju4.redhat-epel ] && git clone https://github.com/juju4/ansible-redhat-epel $rolesdir/juju4.redhat-epel
[ ! -d $rolesdir/juju4.syslogclient ] && git clone https://github.com/juju4/ansible-syslogclient $rolesdir/juju4.syslogclient
## galaxy naming: kitchen fails to transfer symlink folder
#[ ! -e $rolesdir/juju4.polarproxy ] && ln -s ansible-polarproxy $rolesdir/juju4.polarproxy
[ ! -e $rolesdir/juju4.polarproxy ] && cp -R $rolesdir/ansible-polarproxy $rolesdir/juju4.polarproxy

## don't stop build on this script return code
true

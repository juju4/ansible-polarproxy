import os

import testinfra.utils.ansible_runner

import pytest

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


@pytest.mark.parametrize("filename,filemode,user", [
    ("/var/_polarproxy/PolarProxy/System.Runtime.dll", 0o744, "_polarproxy"),
    ("/etc/systemd/system/PolarProxy.service", 0o644, "root"),
    ("/var/_polarproxy/PolarProxy/PolarProxy", 0o744, "_polarproxy"),
])
def test_files(host, filename, filemode, user):
    f = host.file(filename)
    assert f.exists
    assert f.user == user
    assert f.mode == filemode

# FIXME! not detected correctly
# def test_port_is_listening(host):
#    socket = host.socket("tcp://10443")
#    assert(socket.is_listening)

def test_curl1(host):
    command = """curl --cacert /var/log/PolarProxy/polarproxy.cer -L -D - \
            https://www.google.com"""
    with host.sudo("nobody"):
        cmd = host.run(command)
        assert 'HTTP/1.1 200 OK' in cmd.stdout


def test_curl2(host):
    command = """curl --cacert /var/log/PolarProxy/polarproxy.cer -L -D - \
            https://expired.badssl.com"""
    with host.sudo("nobody"):
        cmd = host.run(command)
        assert 'HTTP/1.1 200 OK' in cmd.stdout

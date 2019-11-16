require 'serverspec'

# Required by serverspec
set :backend, :exec

## Use Junit formatter output, supported by jenkins but how to pass environment through kitchen?
## http://www.agilosoftware.com/blog/configuring-test-kitchen-output-jenkins/
## https://github.com/test-kitchen/busser-serverspec/issues/9
if ENV.has_key?('SERVERSPEC_JUNIT')
  require 'yarjuf'
  RSpec.configure do |c|
      c.formatter = 'JUnit'
  end
end
#require 'yarjuf'
#RSpec.configure do |c|
#  c.formatter = 'JUnit'
#end

describe file('/var/_polarproxy/PolarProxy/System.Runtime.dll') do
  it { should be_file }
  it { should be_mode 744 }
  it { should be_owned_by '_polarproxy' }
end
describe file('/var/_polarproxy/PolarProxy/PolarProxy') do
  it { should be_file }
  it { should be_mode 744 }
  it { should be_owned_by '_polarproxy' }
end
describe file('/etc/systemd/system/PolarProxy.service') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
end

describe port(10443) do
  it { should be_listening }
end

describe command('curl --cacert /var/log/PolarProxy/polarproxy.pem -L -D - https://www.google.com') do
  let(:sudo_options) { '-u nobody -H' }
  its(:stdout) { should match /<title>Google<\/title>/ }
# HTTP/1.1 on Centos7 and Ubuntu 16.04, 2 on Ubuntu 18.04
  its(:stdout) { should match /HTTP\/.* 200/ }
  its(:stderr) { should_not match /No such file or directory/ }
  its(:exit_status) { should eq 0 }
end

describe command('curl -k --cacert /var/log/PolarProxy/polarproxy.pem -L -D - https://expired.badssl.com') do
  let(:sudo_options) { '-u nobody -H' }
  its(:stdout) { should match /HTTP\/1.1 200 OK/ }
  its(:stderr) { should_not match /No such file or directory/ }
#  its(:stderr) { should_not match /OpenSSL SSL_connect: SSL_ERROR_SYSCALL in connection to/ }
  its(:exit_status) { should eq 0 }
end

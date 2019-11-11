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

describe command('curl --cacert /var/log/PolarProxy/polarproxy.cer -L -D - https://www.google.com') do
  let(:sudo_options) { '-u nobody -H' }
  its(:stdout) { should match /HTTP\/1.1 200 OK/ }
  its(:stderr) { should match /No such file or directory/ }
  its(:exit_status) { should eq 0 }
end

describe command('curl --cacert /var/log/PolarProxy/polarproxy.cer -L -D - https://expired.badssl.com') do
  let(:sudo_options) { '-u nobody -H' }
  its(:stdout) { should match /HTTP\/1.1 200 OK/ }
  its(:stderr) { should match /No such file or directory/ }
  its(:exit_status) { should eq 0 }
end

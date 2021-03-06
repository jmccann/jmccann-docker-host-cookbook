describe 'jmccann-docker-host::default' do
  # Inspec examples can be found at
  # https://docs.chef.io/inspec_reference.html

  it 'starts service' do
    expect(service('docker')).to be_installed
    expect(service('docker')).to be_enabled
    expect(service('docker')).to be_running
  end

  it 'uses correct storage driver' do
    expect(command('docker info').stdout).to include('Storage Driver: overlay2')
  end
end

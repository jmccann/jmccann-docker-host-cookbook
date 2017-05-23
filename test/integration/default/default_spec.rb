describe 'jmccann-docker-host::default' do
  # Inspec examples can be found at
  # https://docs.chef.io/inspec_reference.html

  it 'starts service' do
    expect(service('docker')).to be_installed
    expect(service('docker')).to be_enabled
    expect(service('docker')).to be_running
  end

  it 'installs correct version' do
    expect(command('docker version').exit_status).to eq 0
    expect(command('docker version').stdout).to include('17.05.0')
  end

  it 'uses aufs storage driver' do
    expect(command('docker info').stdout).to include('Storage Driver: aufs')
  end
end

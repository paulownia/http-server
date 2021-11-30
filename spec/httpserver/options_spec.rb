require 'spec_helper'
require 'httpserver/version'
require 'httpserver/options'

describe HTTPServer::Options do
  it 'uses default settings without cli options' do
    opts = HTTPServer::Options.get([])
    expect(opts[:BindAddresses]).to eq ['localhost']
    expect(opts[:DocumentRoot]).to eq File.expand_path('./')
    expect(opts[:Port]).to eq 8080
  end

  it 'can parse cli options' do
    opts = HTTPServer::Options.get(['-a', '10.200.1.100', '-p', '9999', './doc_roottttt'])
    expect(opts[:BindAddresses]).to eq ['10.200.1.100']
    expect(opts[:DocumentRoot]).to eq File.expand_path('./doc_roottttt')
    expect(opts[:Port]).to eq 9999
  end

  it 'can parse multi bind address' do
    opts = HTTPServer::Options.get(['-a', '127.0.0.1,192.168.1.105'])
    expect(opts[:BindAddresses]).to eq ['127.0.0.1', '192.168.1.105']
  end
end

require 'spec_helper'
require 'httpserver/version'
require 'httpserver/options'
require 'httpserver/server'
require 'net/http'

describe HTTPServer do
  it 'has a version number' do
    expect(HTTPServer::VERSION).not_to be nil
  end

  it 'can parse cli options' do
    opts = HTTPServer::Options.get(['-a', '10.200.1.100', '-p', '9999', './doc_roottttt'])
    expect(opts[:BindAddress]).to eq '10.200.1.100'
    expect(opts[:DocumentRoot]).to eq File.expand_path('./doc_roottttt')
    expect(opts[:Port]).to eq 9999
  end

  it 'can boot server' do
    opt = HTTPServer::Options.get(['./spec/htdocs'])
    opt[:Port] = 8888
    server = HTTPServer::Server.new(opt)
    Thread.new do
      server.start
    end

    Net::HTTP.start('localhost', 8888) do |http|
      res = http.get('/test.html')
      expect(res.code).to eq '200'
    end

    server.stop
  end
end

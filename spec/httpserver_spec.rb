require 'spec_helper'
require 'httpserver/version'
require 'httpserver/options'
require 'httpserver/server'
require 'net/http'

describe HTTPServer do
  it 'has a version number' do
    expect(HTTPServer::VERSION).not_to be nil
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

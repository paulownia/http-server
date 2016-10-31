require "httpserver/version"
require "httpserver/server"
require "httpserver/options"

options = HTTPServer::Options.get
server = HTTPServer::Server.new(options)

trap(:INT) do
  server.stop
end

server.start

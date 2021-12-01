require 'webrick'
require 'httpserver/mime_types'
require 'httpserver/handler'

module HTTPServer
  #
  # wrapping webrick http server
  #
  class Server
    def initialize(options)
      @server = Utils.create_server(options)
      @server.mount("/", CustomErrorPageFileHandler, options[:DocumentRoot], options)
    end

    def start
      @server.start
    end

    def stop
      @server.shutdown
    end

    WEBrick::HTTPServlet::FileHandler.add_handler('rb', WEBrick::HTTPServlet::CGIHandler)
    WEBrick::HTTPServlet::FileHandler.add_handler('erb', WEBrick::HTTPServlet::ERBHandler)
    %w[html js mjs css txt png jpg].each do |ext|
      WEBrick::HTTPServlet::FileHandler.add_handler(ext, HTTPServer::UncachedFileHandler)
    end
  end

  #
  # utility functions
  #
  module Utils
    def create_server(options)
      server = WEBrick::HTTPServer.new(
        DoNotListen: true,
        Logger: options[:Logger],
        AccessLog: options[:AccessLog],
        ServerType: options[:ServerType]
      )
      options[:BindAddresses].each { |addr|
        server.listen(addr, options[:Port])
      }
      server.config[:MimeTypes] = HTTPServer::MimeTypes::Default
      server
    end
    module_function :create_server
  end
end

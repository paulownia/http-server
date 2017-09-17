require 'webrick'
require 'httpserver/mime_types'
require 'httpserver/handler'
require 'httpserver/https'

module HTTPServer
  class Server
    def initialize(options)
      if options[:SSLEnable]
        self.extend HTTPServer::HTTPs
      end

      @server = create_server(options)
      @server.config[:MimeTypes] = HTTPServer::MimeTypes::Default

      doc_root = options[:DocumentRoot]

      file_handler_option = {
        FancyIndexing: true
      }

      WEBrick::HTTPServlet::FileHandler.add_handler('rb', WEBrick::HTTPServlet::CGIHandler)
      WEBrick::HTTPServlet::FileHandler.add_handler('erb', WEBrick::HTTPServlet::ERBHandler)
      %w(html js mjs css txt png jpg).each do |ext|
        WEBrick::HTTPServlet::FileHandler.add_handler(ext, HTTPServer::UncachedFileHandler)
      end

      @server.mount_proc('/') do |req, res|
        begin
          # res.keep_alive = false
          WEBrick::HTTPServlet::FileHandler.new(@server, doc_root, file_handler_option).service(req, res)
        rescue WEBrick::HTTPStatus::Error => e
          page = File.join(doc_root, options[:ErrorPageDir], e.code.to_s + '.html')

          raise e unless File.exist? page

          res.status = e.code
          res.content_type = 'text/html'
          res.content_length = File.stat(page).size
          File.open(page) do |file|
            res.body = file.read
          end
        end
      end
    end

    def start
      @server.start
    end

    def stop
      @server.shutdown
    end

    private

    def create_server(options)
      server = WEBrick::HTTPServer.new(
        DoNotListen: true,
        Port: options[:Port],
        Logger: options[:Logger],
        AccessLog: options[:AccessLog],
        ServerType: options[:ServerType],
      )
      options[:BindAddresses].each { |addr|
        server.listen(addr, options[:Port])
      }
      server
    end
  end
end

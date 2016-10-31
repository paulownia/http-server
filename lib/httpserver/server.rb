require 'webrick'

module HTTPServer
  class Server
    def initialize(options)
      @server = WEBrick::HTTPServer.new(
        :BindAddress => options[:BindAddress],
        :Port => options[:Port],
      )

      docRoot = options[:DocumentRoot]
 
      fileHandlerOption = {
        :FancyIndexing => true
      }

      @server.mount_proc('/') do |req, res|
        begin
          WEBrick::HTTPServlet::FileHandler.new(@server, docRoot, fileHandlerOption).service(req, res)
        rescue WEBrick::HTTPStatus::Error => e
          page = File.join(options[:ErrorPageDir] , e.code.to_s + ".html")

          if File.exist? page
            res.status = e.code
            res.content_type = "text/html"
            res.content_length = File.stat(page).size
            File.open(page) do |file|
              res.body = file.read
            end
          else
            raise e
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
  end
end

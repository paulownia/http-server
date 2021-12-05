require 'webrick/httpservlet/filehandler'
require 'webrick/httputils'

module HTTPServer
  class UncachedFileHandler < WEBrick::HTTPServlet::DefaultFileHandler
    def do_GET(req, res)
      if req['range']
        super(req, res)
        return
      end

      st = File::stat(@local_path)
      mtime = st.mtime

      mtype = WEBrick::HTTPUtils::mime_type(@local_path, @config[:MimeTypes])
      res['cache-control'] = 'no-store'
      res['content-type'] = mtype
      res['content-length'] = st.size.to_s
      res.body = File.open(@local_path, "rb")
    end
  end

    #
  # A webrick servlet wrapping FileHandler
  #
  class CustomErrorPageFileHandler < WEBrick::HTTPServlet::AbstractServlet
    def initialize(server, root, options = {})
      @fileHandler = WEBrick::HTTPServlet::FileHandler.new(server, root, { FancyIndexing: true })
      @options = options
      # @logger = WEBrick::BasicLog.new
    end

    def service(req, res)
      @fileHandler.service(req, res)
    rescue WEBrick::HTTPStatus::Error => error
      handle_http_error(res, error)
    end

    def handle_http_error(res, error)
      page = File.join(@options[:DocumentRoot], @options[:ErrorPageDir], error.code.to_s + '.html')
      raise error unless File.exist? page
      res.status = error.code
      res.content_type = 'text/html'
      res.content_length = File.stat(page).size
      File.open(page) { |file| res.body = file.read }
    end
  end
end

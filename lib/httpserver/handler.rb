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
end

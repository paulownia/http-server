require 'optparse'

module HTTPServer
  module Options
    def get(args = ARGV)
      options = {
        :Port => 8080,
        :ErrorPageDir => "./errors",
        :DocumentRoot => '.',
        :BindAddress => '127.0.0.1',
      }

      opts = OptionParser.new

      opts.banner = "Usage: http-server [options] [/path/to/document_root]"

      opts.on("-p VAL", "--port=VAL", OptionParser::DecimalInteger, "Listen Port (default 8080)") do |value|
        options[:Port] = value
      end

      opts.on("-a VAL", "--bind-address=VAL", String, "Bind Address (default 127.0.0.1)") do |value|
        options[:BindAddress] = value
      end

      opts.on("-x VAL", "--error-page=VAL", String, "Error Pages Directory (default ${document root}/errors)") do |value|
        options[:ErrorPageDir] = value
      end

      opts.parse!(args)

      if args[0]
        options[:DocumentRoot] = args[0]
      end

      options
    end

    module_function :get
  end
end

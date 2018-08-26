require 'optparse'
require 'webrick'

module HTTPServer
  module Options
    def get(args = ARGV)
      options = {
        :Port => 8080,
        :ErrorPageDir => "./errors",
        :DocumentRoot => Dir.pwd,   # current is / if damonized, so get current dir before fork
        :BindAddress => '127.0.0.1',
        :LogLevel => WEBrick::BasicLog::ERROR,
        :LogFile => nil,
        :Logger => nil,
        :AccessLogFile => nil,
        :AccessLog => nil,
        :ServerType => nil
      }

      opts = OptionParser.new

      opts.banner = "Usage: http-server [options] [/path/to/document_root]"

      opts.on("-p VAL", "--port=VAL", OptionParser::DecimalInteger, "Listen Port (default 8080)") do |value|
        options[:Port] = value
      end

      opts.on("-a VAL", "--bind-address=VAL", String, "Bind Address (default 127.0.0.1)") do |value|
        options[:BindAddress] = value
      end

      opts.on("-d", "--daemonize", "Boot as Daemon") do
        options[:ServerType] = WEBrick::Daemon
      end

      opts.on("-x VAL", "--error-page=VAL", String, "Error Pages Directory (default ${document root}/errors)") do |value|
        options[:ErrorPageDir] = value
      end

      opts.on("-l VAL", "--log-level=VAL", String, "Log Level (debug, info, warn, error, fatal, default error)") do |value|
        options[:LogLevel] = to_webrick_log_level(value)
      end

      opts.on("--log-file=VAL", String, "error log file (default stderr)") do |value|
        options[:LogFile] = File.join(Dir.pwd, value)
      end

      opts.on("--access-log-file=VAL", String, "access log file (default stderr)") do |value|
        options[:AccessLogFile] = File.join(Dir.pwd, value)
      end

      begin
        opts.parse!(args)
      rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
        puts e.message
        puts opts.help
        exit(1)
      end

      if args[0]
        options[:DocumentRoot] = File.join(options[:DocumentRoot], args[0])
      end

      if options[:LogFile].nil?
        options[:Logger] = WEBrick::BasicLog.new(nil, options[:LogLevel])
      else
        f = File.open(options[:LogFile], 'a')
        options[:Logger] = WEBrick::BasicLog.new(f, options[:LogLevel])
      end

      if options[:AccessLogFile]
        f = File.open(options[:AccessLogFile], 'a')
        options[:AccessLog] = [[f, WEBrick::AccessLog::CLF]]
      end

      options
    end

    class << self
      private
      def to_webrick_log_level log_level
        begin
          WEBrick::BasicLog.const_get(log_level.upcase)
        rescue
          puts "Invalid log level #{log_level}"
          WEBrick::BasicLog::ERROR
        end
      end
    end

    module_function :get
  end
end

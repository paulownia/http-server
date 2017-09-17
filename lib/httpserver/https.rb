require 'webrick'
require 'webrick/https'
require 'openssl'


module HTTPServer
  module HTTPs
    def create_server(options)
      begin
        crt = File.open(options[:SSLCertificate])
        key = File.open(options[:SSLPrivateKey])

        crt_obj = OpenSSL::X509::Certificate.new(crt)
        key_obj = OpenSSL::PKey::RSA.new(key)

        server = WEBrick::HTTPServer.new(
          :BindAddress => options[:BindAddress],
          :Port => options[:Port],
          :Logger => WEBrick::BasicLog.new(nil, options[:LogLevel]),
          :AccessLog => options[:AccessLog],
          :ServerType => options[:ServerType],
          :SSLEnable => true,
          :SSLCertificate => crt_obj,
          :SSLPrivateKey => key_obj,
        )
        options[:BindAddresses].each { |addr|
          server.listen(addr, options[:Port])
        }
        server
      ensure
        crt.close
        key.close
      end

    end
  end
end


require 'webrick'
require 'webrick/https'
require 'openssl'
require "socket"

module HTTPServer
  module HTTPs
    def create_server(options)
      if options[:AutoSSL]
        return auto_ssl(options)
      end

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

    def auto_ssl(options)
      rsa = OpenSSL::PKey::RSA.new(1024)

      name = OpenSSL::X509::Name.new
      name.add_entry("C", "JP")
      name.add_entry("ST", "Tokyo")
      name.add_entry("CN", "localhost")

      crt = OpenSSL::X509::Certificate.new
      crt.not_before = Time.now
      crt.not_after  = Time.now + 24*60*60
      crt.public_key = rsa.public_key
      crt.serial = 1
      crt.issuer = name
      crt.subject = name
      crt.sign(rsa, "sha1")

      WEBrick::HTTPServer.new(
        :BindAddress => options[:BindAddress],
        :Port => options[:Port],
        :Logger => WEBrick::BasicLog.new(nil, options[:LogLevel]),
        :SSLEnable => true,
        :SSLCertificate => crt,
        :SSLPrivateKey => rsa,
      )
    end
  end
end


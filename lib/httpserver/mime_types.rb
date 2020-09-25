module HTTPServer
  module MimeTypes
    Additional = {
      "mjs" => "application/javascript",
      "erb" => "text/html"
    }

    Default = WEBrick::HTTPUtils::DefaultMimeTypes.merge(Additional)
  end
end

# HTTPServer

An HTTP Server for testing. It starts up with a simple command and serves the files in the current directory.

## Install

```
$ rake build
$ gem install pkg/http-server-x.x.x.gem
```

## Usage

Starting up http server

```
$ http-server
```

The current directory is used as the document root.

If you will specify ```htdocs``` as document root without cd,

```
$ http-server htdocs
```

## Custom Error Page

Customizing 404 error page, you create './errors/404.html' on document root.

By default, ${document root}/errors/${error code}.html is used as the error page.

If you will change the directory, using -x or --error-page option.

```
$ http-server -x err
```

-x and --error-page is relative directory to document root.


## Options

```
-h Print help
-p Port (default 8080)
-a Bind Address (default 127.0.0.1)
-x Error page directory (relative path to the document root. default './errors')
-l Log Level (default error)
```

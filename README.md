# HTTPServer

Simple HTTP Server for testing, that serves static contents on your PC.


## Usage

Starting http server

```
$ http-server
```

Document root is current directory.

If you will specify ./htdocs as document root, type

```
$ http-server ./htdocs
```

## Error Page

Customizing 404 error page, you create 'errors/404.html' on document root.

If you will change error page directory to ./htdocs/errors, use --error-page-on  option


```
$ http-server --error-page-in errors ./htdocs
```

--error-page-in is relative directory to document root.


## options

```
-p Port (default 8080)
-a Bind Address (default 127.0.0.1)
```

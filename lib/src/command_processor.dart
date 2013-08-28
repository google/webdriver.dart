part of webdriver;

class CommandProcessor {
  final Uri _uri;

  String get _host => _uri.host;
  int get _port => _uri.port;
  String get path => _uri.path;

  String get url => _uri.toString();

  CommandProcessor([
      String host = 'localhost',
      int port = 4444,
      String path = '/wd/hub']) :
      _uri = new Uri(scheme: 'http', host: host, port: port, path: path) {
    assert(!this._host.isEmpty);
  }

  void _failRequest(Completer completer, error, [stackTrace]) {
    if (stackTrace == null) {
      stackTrace = getAttachedStackTrace(error);
    }
    completer
        .completeError(new WebDriverError(-1, error.toString()), stackTrace);
  }

  /**
   * Execute a request to the WebDriver server. [httpMethod] should be
   * one of 'GET', 'POST', or 'DELETE'. [command] is the text to append
   * to the base URL path to get the full URL. [params] are the additional
   * parameters. If a [List] or [Map] they will be posted as JSON parameters.
   * If a number or string, "/params" is appended to the URL.
   */
  Future _serverRequest(String httpMethod, String command, {params}) {
    const successCodes = const [ HttpStatus.OK, HttpStatus.NO_CONTENT ];
    var completer = new Completer();

    try {
      var path = command;
      if (params != null) {
        if (params is num || params is String) {
          path = '$path/$params';
          params = null;
        } else if (httpMethod != 'POST') {
          throw new Exception(
            'The http method called for ${command} is ${httpMethod} but it '
            'must be POST if you want to pass the JSON params '
            '${JSON.encode(params)}');
        }
      }

      var client = new HttpClient();
      client.open(httpMethod, _host, _port, path).then((req) {
        req.followRedirects = false;
        req.headers.add(HttpHeaders.ACCEPT, "application/json");
        req.headers.contentType = _CONTENT_TYPE_JSON;
        if (params != null) {
          var body = UTF8.encode(JSON.encode(params));
          req.contentLength = body.length;
          req.add(body);
        } else {
          req.contentLength = 0;
        }
        return req.close();
      }).then((HttpClientResponse rsp) {
        return _toStringEscapeNUL(rsp)
            .then((String results) {

              var status = 0;
              String message = null;
              var value = null;
              // 4xx responses send plain text; others send JSON
              if (HttpStatus.BAD_REQUEST <= rsp.statusCode
                  && rsp.statusCode < HttpStatus.INTERNAL_SERVER_ERROR) {
                if (rsp.statusCode == HttpStatus.NOT_FOUND) {
                  status = 9; // UnkownCommand
                } else {
                  status = 13; // UnknownError
                }
                message = results;
              } else if (!results.isEmpty) {
                Map values = JSON.decode(results);
                if (values.containsKey('status')) {
                  status = values['status'];
                }
                if (values.containsKey('value')) {
                  value = values['value'];
                }
                if (values.containsKey('message')) {
                  message = values['message'];
                }
              }

              if (status != 0) {
                completer.completeError(new WebDriverError(status, message));
              } else if (!successCodes.contains(rsp.statusCode)) {
                completer.completeError(new WebDriverError(-1,
                    'Unexpected response ${rsp.statusCode}; $results'));
              } else {
                completer.complete(value);
              }
            });
      }).catchError((error) => _failRequest(completer, error));
    } catch (e, s) {
      _failRequest(completer, e, s);
    }
    return completer.future;
  }

  Future get(String extraPath) => _serverRequest('GET', _command(extraPath));


  Future post(String extraPath, [params]) =>
      _serverRequest('POST', _command(extraPath), params: params);


  Future delete(String extraPath) =>
      _serverRequest('DELETE', _command(extraPath));

  String _command(String extraPath) {
    var command;
    if (extraPath.startsWith('/')) {
      command = '${path}$extraPath';
    } else {
      command = '${path}/$extraPath';
    }
    if (command.endsWith('/')) {
      command = command.substring(0, command.length - 1);
    }
    return command;
  }
}

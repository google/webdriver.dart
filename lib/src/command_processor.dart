part of webdriver;

class CommandProcessor {
  String _host;
  int _port;
  String _path;
  String _url;

  String get path => _path;
  String get url => _url;

  /**
   * The default URL for WebDriver remote server is
   * http://localhost:4444/wd/hub.
   */
  CommandProcessor._fromUrl([this._url = 'http://localhost:4444/wd/hub']) {
    Uri uri = Uri.parse(this._url);
    _port = uri.port;
    _host = uri.host;
    _path = uri.path;
  }

  CommandProcessor([
      this._host = 'localhost',
      this._port = 4444,
      this._path = '/wd/hub']) {
    _url = 'http://$_host:$_port$_path';
  }

  void _failRequest(Completer completer, error, [stackTrace]) {
    if (completer != null) {
      var trace = stackTrace != null ? stackTrace : getAttachedStackTrace(error);
      completer.completeError(new WebDriverError(-1, error.toString()), trace);
    }
  }

  /**
   * Execute a request to the WebDriver server. [httpMethod] should be
   * one of 'GET', 'POST', or 'DELETE'. [command] is the text to append
   * to the base URL path to get the full URL. [params] are the additional
   * parameters. If a [List] or [Map] they will be posted as JSON parameters.
   * If a number or string, "/params" is appended to the URL.
   */
  Future _serverRequest(String httpMethod, String command, {params}) {
    var status = 0;
    var results = null;
    var message = null;
    var successCodes = [ 200, 204 ];
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
            '${json.stringify(params)}');
        }
      }

      var client = new HttpClient();
      client.open(httpMethod, _host, _port, path).then((req) {
        req.followRedirects = false;
        req.headers.add(HttpHeaders.ACCEPT, "application/json");
        req.headers.contentType
            = new ContentType("application", "json", charset: "utf-8");
        if (params != null) {
          var body = json.stringify(params);
          req.write(body);
        }
        req.close().then((rsp) {
          List<int> body = new List<int>();
          rsp.listen(body.addAll, onDone: () {
            var value = null;
            // For some reason we get a bunch of NULs on the end
            // of the text and the json.parse blows up on these, so
            // strip them.
            // These NULs can be seen in the TCP packet, so it is not
            // an issue with character encoding; it seems to be a bug
            // in WebDriver stack.
            results = new String.fromCharCodes(body)
                .replaceAll(new RegExp('\u{0}*\$'), '');
            if (!successCodes.contains(rsp.statusCode)) {
              _failRequest(completer,
                  'Unexpected response ${rsp.statusCode}; $results');
              return;
            }
            if (status == 0 && results.length > 0) {
              // 4xx responses send plain text; others send JSON.
              if (rsp.statusCode < 400) {
                results = json.parse(results);
                status = results['status'];
              }
              if (results is Map && (results as Map).containsKey('value')) {
                value = results['value'];
              }
              if (value is Map && value.containsKey('message')) {
                message = value['message'];
              }
            }
            if (status == 0) {
              completer.complete(value);
            }
          }, onError: (error) {
            _failRequest(completer, error);
          });
        })
        .catchError((error) {
          _failRequest(completer, error);
        });
      })
      .catchError((error) {
        _failRequest(completer, error);
      });
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
    if (extraPath.startsWith('/')) {
      return '${_path}$extraPath';
    } else {
      return '${_path}/$extraPath';
    }
  }
}

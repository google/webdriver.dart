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
    // Break out the URL components.
    var re = new RegExp('[^:/]+://([^/]+)(/.*)');
    var matches = re.firstMatch(_url);
    _host = matches[1];
    _path = matches[2];
    var idx = _host.indexOf(':');
    if (idx >= 0) {
      _port = int.parse(_host.substring(idx+1));
      _host = _host.substring(0, idx);
    } else {
      _port = 80;
    }
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
      completer.completeError(new WebDriverError(-1, error), trace);
    }
  }

  /**
   * Execute a request to the WebDriver server. [http_method] should be
   * one of 'GET', 'POST', or 'DELETE'. [command] is the text to append
   * to the base URL path to get the full URL. [params] are the additional
   * parameters. If a [List] or [Map] they will be posted as JSON parameters.
   * If a number or string, "/params" is appended to the URL.
   */
  void _serverRequest(String http_method, String command, Completer completer,
                      {List successCodes, params}) {
    var status = 0;
    var results = null;
    var message = null;
    if (successCodes == null) {
      successCodes = [ 200, 204 ];
    }
    try {
      var path = command;
      if (params != null) {
        if (params is num || params is String) {
          path = '$path/$params';
          params = null;
        } else if (http_method != 'POST') {
          throw new Exception(
            'The http method called for ${command} is ${http_method} but it '
            'must be POST if you want to pass the JSON params '
            '${json.stringify(params)}');
        }
      }

      var client = new HttpClient();
      client.open(http_method, _host, _port, path).then((req) {
        req.followRedirects = false;
        req.headers.add(HttpHeaders.ACCEPT, "application/json");
        req.headers.add(
            HttpHeaders.CONTENT_TYPE, 'application/json;charset=UTF-8');
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
              completer = null;
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
            completer = null;
          });
        })
        .catchError((error) {
          _failRequest(completer, error);
          completer = null;
        });
      })
      .catchError((error) {
        _failRequest(completer, error);
        completer = null;
      });
    } catch (e, s) {
      _failRequest(completer, e, s);
      completer = null;
    }
  }

  Future get(String extraPath) {
    var completer = new Completer();
    _serverRequest('GET', '${_path}/$extraPath', completer);
    return completer.future;
  }

  Future post(String extraPath, [params]) {
    var completer = new Completer();
    _serverRequest('POST', '${_path}/$extraPath', completer,
        params: params);
    return completer.future;
  }

  Future delete(String extraPath) {
    var completer = new Completer();
    _serverRequest('DELETE', '${_path}/$extraPath', completer);
    return completer.future;
  }
}
part of webdriver;

final ContentType _contentTypeJson = new ContentType("application", "json", charset: "utf-8");
const _defaultDecoder = const JsonDecoder();

class _CommandProcessor {

  final HttpClient client = new HttpClient();

  Object post(Uri uri, dynamic params, {Converter<String, dynamic> decoder: _defaultDecoder}) async {
    HttpClientRequest request = await client.postUrl(uri);
    _setUpRequest(request);
    request.headers.contentType = _contentTypeJson;
    request.encoding = UTF8;
    request.write(JSON.encode(params));
    return await _processResponse(await request.close(), decoder);
  }

  Object get(Uri uri, {Converter<String, dynamic> decoder: _defaultDecoder}) async {
    HttpClientRequest request = await client.getUrl(uri);
    _setUpRequest(request);
    return await _processResponse(await request.close(), decoder);
  }

  Object delete(Uri uri, {Converter<String, dynamic> decoder: _defaultDecoder}) async {
    HttpClientRequest request = await client.deleteUrl(uri);
    _setUpRequest(request);
    return await _processResponse(await request.close(), decoder);
  }

  _processResponse(HttpClientResponse response, Converter<String, dynamic> decoder) async {
    var respBody = decoder.convert(await UTF8.decodeStream(response));
    if (response.statusCode < 200 || response.statusCode > 299 || (respBody is Map && respBody['status'] != 0)) {
      // TODO(DrMarcII) FIXME
      throw new WebDriverException(httpStatusCode: response.statusCode, httpReasonPhrase: response.reasonPhrase, jsonResp: respBody);
    }
    if (respBody is Map) {
      return respBody['value'];
    }
    return respBody;
  }

  void _setUpRequest(HttpClientRequest request) {
    request.followRedirects = false;
    request.headers.add(HttpHeaders.ACCEPT, "application/json");
    request.headers.add(HttpHeaders.ACCEPT, "application/json");
    request.headers.add(HttpHeaders.ACCEPT_CHARSET, UTF8.name);
    request.headers.add(HttpHeaders.CACHE_CONTROL, "no-cache");
  }
}
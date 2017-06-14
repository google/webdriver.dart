// Copyright 2017 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import 'dart:convert' show JSON;

import 'package:sync_http/sync_http.dart';

import '../exception.dart' show WebDriverException;

/// Handles responses from the JSON wire protocol.
dynamic processJsonWireResponse(SyncHttpClientResponse response, bool value) {
Map responseBody;
try {
responseBody = JSON.decode(response.body);
} catch (e) {}

if (response.statusCode < 200 ||
response.statusCode > 299 ||
(responseBody is Map &&
responseBody['status'] != null &&
responseBody['status'] != 0)) {
throw new WebDriverException(
httpStatusCode: response.statusCode,
httpReasonPhrase: response.reasonPhrase,
jsonResp: responseBody);
}
if (value && responseBody is Map) {
return responseBody['value'];
}
return responseBody;
}

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
import 'package:webdriver/sync_core.dart';

/// Inferred spec and sessionId from a session creation request.
class InferredResponse {
  final String sessionId;

  final WebDriverSpec spec;

  InferredResponse(this.sessionId, this.spec);
}

/// Infers the spec during session creation.
dynamic inferSessionResponseSpec(SyncHttpClientResponse response, bool _) {
  Map responseBody;
  try {
    responseBody = JSON.decode(response.body);
  } catch (e) {}

  if (response.statusCode < 200 || response.statusCode > 299) {
    // Throw exception.
  }

  if (responseBody.keys.length > 1) {
    // JSON
    return new InferredResponse(
        responseBody['sessionId'], WebDriverSpec.JsonWire);
  } else if (responseBody.keys == 1) {
    // W3C
    return new InferredResponse(
        responseBody['value']['sessionId'], WebDriverSpec.W3c);
  } else {
    // Throw exception.
  }

  return response;
}

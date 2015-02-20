// Copyright 2015 Google Inc. All Rights Reserved.
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

library webdriver;

import 'dart:async' show Future, Stream, StreamController;
import 'dart:collection' show UnmodifiableMapView;
import 'dart:convert' show JSON, UTF8;
import 'dart:io'
    show
        ContentType,
        HttpClient,
        HttpClientRequest,
        HttpClientResponse,
        HttpHeaders;
import 'dart:math' show Point, Rectangle;

import 'package:crypto/crypto.dart' show CryptoUtils;

import 'async_helpers.dart' show Lock, waitFor;
export 'async_helpers.dart' show waitFor;

part 'src/alert.dart';
part 'src/capabilities.dart';
part 'src/command_processor.dart';
part 'src/common.dart';
part 'src/exception.dart';
part 'src/keyboard.dart';
part 'src/logs.dart';
part 'src/mouse.dart';
part 'src/navigation.dart';
part 'src/options.dart';
part 'src/target_locator.dart';
part 'src/web_driver.dart';
part 'src/web_element.dart';
part 'src/window.dart';

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

import '../common.dart';
import '../keyboard.dart';
import '../web_driver.dart';

class W3cKeyboard extends Keyboard {
  final WebDriver _driver;
  final Resolver _resolver;

  W3cKeyboard(this._driver) : _resolver = new Resolver(_driver, '');

  @override
  void sendChord(Iterable<String> chordToSend) {
    final keyDownActions = <Map<String, String>>[];
    final keyUpActions = <Map<String, String>>[];
    for (String s in chordToSend) {
      keyDownActions.add({"type": "keyDown", "value": s});
      keyUpActions.add({"type": "keyUp", "value": s});
    }
    _resolver.post('actions', {
      'actions': [
        {
          "type": "key",
          "id": "keys",
          "actions":
              keyDownActions + keyUpActions.reversed.toList(growable: false)
        }
      ]
    });
  }

  @override
  void sendKeys(String keysToSend) {
    final keyActions = <Map<String, String>>[];
    for (int i = 0; i < keysToSend.length; ++i) {
      keyActions.add({"type": "keyDown", "value": keysToSend[i]});
      keyActions.add({"type": "keyUp", "value": keysToSend[i]});
    }
    _resolver.post('actions', {
      'actions': [
        {"type": "key", "id": "keys", "actions": keyActions}
      ]
    });
  }

  @override
  String toString() => '$_driver.keyboard';

  @override
  int get hashCode => _driver.hashCode;

  @override
  bool operator ==(other) => other is W3cKeyboard && other._driver == _driver;
}

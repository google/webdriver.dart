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

library webdriver.async_helpers;

import 'dart:async' show Completer, Future;

import 'package:test/test.dart' show expect, isNotNull;

const defaultInterval = const Duration(milliseconds: 500);
const defaultTimeout = const Duration(seconds: 5);

const clock = const Clock();

Future waitFor(condition(), {matcher: isNotNull,
    Duration timeout: defaultTimeout,
    Duration interval: defaultInterval}) => clock.waitFor(condition,
        matcher: matcher, timeout: timeout, interval: interval);

class Clock {
  const Clock();

  /// Sleep for the specified time.
  Future sleep([Duration interval = defaultInterval]) =>
      new Future.delayed(interval);

  /// The current time.
  DateTime get now => new DateTime.now();

  /// Waits until [condition] evaluates to a value that matches [matcher] or
  /// until [timeout] time has passed. If [condition] returns a [Future], then
  /// uses the value of that [Future] rather than the value of [condition].
  ///
  /// If the wait is successful, then the matching return value of [condition]
  /// is returned. Otherwise, if [condition] throws, then that exception is
  /// rethrown. If [condition] doesn't throw then an [expect] exception is
  /// thrown.
  Future waitFor(condition(), {matcher: isNotNull,
      Duration timeout: defaultTimeout,
      Duration interval: defaultInterval}) async {
    var endTime = now.add(timeout);
    while (true) {
      try {
        var value = await condition();
        expect(value, matcher);
        return value;
      } catch (e) {
        if (now.isAfter(endTime)) {
          rethrow;
        } else {
          await sleep(interval);
        }
      }
    }
  }
}

class Lock {
  Completer _lock;

  Future acquire() async {
    while (isHeld) {
      await _lock.future;
    }
    _lock = new Completer();
  }

  void release() {
    if (!isHeld) {
      throw new StateError('No lock to release');
    }
    _lock.complete();
    _lock = null;
  }

  bool get isHeld => _lock != null;
}

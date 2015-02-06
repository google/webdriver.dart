// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library webdriver.async_helpers;

import 'dart:async' show Completer, Future;
import 'package:matcher/matcher.dart' show expect, isNotNull;

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
    // This return should not be required, but has been added to make analyzer
    // happy.
    return null;
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

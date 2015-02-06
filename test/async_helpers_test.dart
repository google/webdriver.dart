// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library webdriver_test.async_helpers;

import 'dart:async' show Future;

import 'package:unittest/unittest.dart';
import 'package:webdriver/async_helpers.dart';

void main() {
  group('Lock', () {
    test('basic acquire/release', () async {
      var lock = new Lock();
      expect(lock.isHeld, isFalse);
      await lock.acquire();
      expect(lock.isHeld, isTrue);
      lock.release();
      expect(lock.isHeld, isFalse);
      await lock.acquire();
      expect(lock.isHeld, isTrue);
      lock.release();
    });

    test('release without acquiring fails', () {
      var lock = new Lock();
      expect(() => lock.release(), throwsA(new isInstanceOf<StateError>()));
    });

    test('locking prevents acquisition of lock', () async {
      var lock = new Lock();
      var secondLockAcquired = false;
      await lock.acquire();
      lock.acquire().then((_) => secondLockAcquired = true);
      // Make sure that lock is not unacquired just because of timing
      await new Future.delayed(const Duration(seconds: 1));
      expect(secondLockAcquired, isFalse);
      lock.release();
      // Make sure that enough time has occurred that lock is acquired
      await new Future.delayed(const Duration(seconds: 1));
      expect(secondLockAcquired, isTrue);
    });
  });

  group('Clock.waitFor', () {
    var clock = new FakeClock();

    test('that returns a string', () async {
      var count = 0;
      var result = await clock.waitFor(() {
        if (count == 2) return 'webdriver - Google Search';
        count++;
        return count;
      }, matcher: equals('webdriver - Google Search'));

      expect(result, equals('webdriver - Google Search'));
    });

    test('that returns null', () async {
      var count = 0;
      var result = await clock.waitFor(() {
        if (count == 2) return null;
        count++;
        return count;
      }, matcher: isNull);
      expect(result, isNull);
    });

    test('that returns false', () async {
      var count = 0;
      var result = await clock.waitFor(() {
        if (count == 2) return false;
        count++;
        return count;
      }, matcher: isFalse);
      expect(result, isFalse);
    });

    test('that returns a string, default matcher', () async {
      var count = 0;
      var result = await clock.waitFor(() {
        if (count == 2) return 'Google';
        count++;
        return null;
      });
      expect(result, equals('Google'));
    });

    test('throws before successful', () async {
      var count = 0;
      var result = await clock.waitFor(() {
        expect(count, lessThanOrEqualTo(2));
        if (count == 2) {
          count++;
          return false;
        }
        count++;
        return null;
      });
      expect(result, isFalse);
    });

    test('throws if condition throws and timeouts', () async {
      var exception;

      try {
        await clock.waitFor(() => throw 'an exception');
      } catch (e) {
        exception = e;
      }
      expect(exception, 'an exception');
    });

    test('throws if condition never matches', () async {
      var exception;
      try {
        await clock.waitFor(() => null);
      } catch (e) {
        exception = e;
      }
      expect(exception, isNotNull);
    });

    test('uses Future value', () async {
      var result = await clock.waitFor(() => new Future.value('a value'),
          matcher: 'a value');
      expect(result, 'a value');
    });

    test('works with Future exceptions', () async {
      var exception;

      try {
        await clock.waitFor(() => new Future.error('an exception'));
      } catch (e) {
        exception = e;
      }
      expect(exception, 'an exception');
    });

    test('sanity test with real Clock -- successful', () async {
      var clock = new Clock();
      var count = 0;
      var result = await clock.waitFor(() {
        if (count < 2) {
          count++;
          return null;
        } else {
          return 'a value';
        }
      });
      expect(result, 'a value');
    });

    test('sanity test with real Clock -- throws', () async {
      var clock = new Clock();
      var exception;
      try {
        await clock.waitFor(() => throw 'an exception');
      } catch (e) {
        exception = e;
      }
      expect(exception, 'an exception');
    });

    test('sanity test with real Clock -- never matches', () async {
      var clock = new Clock();
      var exception;
      try {
        await clock.waitFor(() => null);
      } catch (e) {
        exception = e;
      }
      expect(exception, isNotNull);
    });
  });
}

/// FakeClock for testing waitFor functionality.
class FakeClock extends Clock {
  var _now = new DateTime(2020);

  @override
  DateTime get now => _now;

  Future sleep([Duration interval = defaultInterval]) {
    _now = _now.add(interval);
    return new Future.value();
  }
}

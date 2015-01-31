library webdriver.lock_test;

import 'dart:async';

import 'package:unittest/unittest.dart';
import 'package:webdriver/src/lock.dart';

void main() {
  group('Lock', () {
    test('basic acquire/release', () async {
      var lock = new Lock();
      expect(lock.isAcquired, isFalse);
      await lock.acquire();
      expect(lock.isAcquired, isTrue);
      lock.release();
      expect(lock.isAcquired, isFalse);
      await lock.acquire();
      expect(lock.isAcquired, isTrue);
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
}

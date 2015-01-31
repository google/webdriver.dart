library webdriver.lock;

import 'dart:async';

class Lock {
  Completer _lock;

  Future acquire() async {
    while (isAcquired) {
      await _lock.future;
    }
    _lock = new Completer();
  }

  void release() {
    if (!isAcquired) {
      throw new StateError('No lock to release');
    }
    _lock.complete();
    _lock = null;
  }

  bool get isAcquired => _lock != null;
}
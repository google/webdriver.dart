library webdriver.command_processor;

import 'dart:async';

/// Interface for HTTP access.
abstract class CommandProcessor {
  Future<Object> post(Uri uri, dynamic params, {bool value: true});

  Future<Object> get(Uri uri, {bool value: true});

  Future<Object> delete(Uri uri, {bool value: true});

  Future close();
}

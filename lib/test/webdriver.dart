// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library test.runner.browser.webdriver;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:webdriver/support/async.dart';
import 'package:webdriver/support/forwarder.dart';
import 'package:webdriver/io.dart' as wd;

import 'package:test/src/backend/test_platform.dart';
import 'package:test/src/runner/browser/browser.dart';
import 'package:shelf/shelf.dart' as shelf;

/// A class for running a browser via WebDriver.
///
/// Most of the communication with the browser is expected to happen via HTTP,
/// so this exposes a bare-bones API. The browser starts as soon as the class is
/// constructed, and is killed when [close] is called.
///
/// Any errors starting or running the process are reported through [onExit].
class WebDriver extends Browser {
  final TestPlatform browser;
  Future<WebDriverForwarder> _forwarder;

  /// Starts a new WebDriver-provisioned open to the given [url], which may
  /// be a [Uri] or a [String].
  ///
  /// If [configFile] (a [File] or [String]) is passed, then WebDriver
  /// configuration will be read from the file it exists, otherwise if
  /// 'test/webdriver_cfg.json' exists configuration will be read from that
  /// file, otherwise sensible defaults will be used.
  ///
  /// The config file should be a JSON object with the following format:
  /// {
  ///   "address": <uri of the WebDriver server>,
  ///   "desired": <map of desired capabilities>
  /// }
  WebDriver(url, {configFile: 'test/webdriver_cfg.json', this.browser}) {
    if (configFile is String) {
      configFile = new File(configFile);
    }

    Uri address;
    Map<String, dynamic> desired = {};
    if (configFile is File && configFile.existsSync()) {
      Map config = _readConfig(configFile);
      if (config.containsKey('address')) {
        address = Uri.parse(config['address']);
      }
      if (config.containsKey('desired')) {
        desired = config['desired'];
      }
    }

    _driver = wd.createDriver(uri: address, desired: desired);
    _forwarder = _driver.then((driver) =>
        new WebDriverForwarder(driver, prefix: 'webdriver/session/1'));
    _onExit = () async {
      var driver = await _driver;
      await driver.get(url.toString());
      while (true) {
        // poll WebDriver server once a second to ensure the session is still
        // alive.
        await driver.currentUrl;
        await clock.sleep(new Duration(seconds: 1));
      }
    }();
  }

  Map<String, dynamic> _readConfig(File configFile) {
    Map config = JSON.decode(configFile.readAsStringSync());
    return _updateConfig(config);
  }

  _updateConfig(config) {
    if (config is String && config.startsWith(r'$')) {
      return Platform.environment[config.substring(1)];
    }
    if (config is Map) {
      var result = {};
      for (var key in config.keys) {
        var value = config[key];
        result[_updateConfig(key)] = _updateConfig(value);
      }
      return result;
    }
    if (config is Iterable) {
      var result = [];
      for (var value in config) {
        result.add(_updateConfig(value));
      }
      return result;
    }
    return config;
  }

  Future<wd.WebDriver> _driver;
  Future _onExit;

  @override
  Future get onExit => _onExit;

  Future<shelf.Response> handler(shelf.Request request) async =>
      (await _forwarder).handler(request);

  @override
  Future close() async {
    await (await _driver).quit();
    try {
      await onExit;
    } catch (e) {}
  }
}

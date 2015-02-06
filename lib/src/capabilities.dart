// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of webdriver;

class Capabilities {
  static const String browserName = "browserName";
  static const String platform = "platform";
  static const String supportsJavascript = "javascriptEnabled";
  static const String takesScreenshot = "takesScreenshot";
  static const String version = "version";
  static const String supportsAlerts = "handlesAlerts";
  static const String supportSqlDatabase = "databaseEnabled";
  static const String supportsLocationContext = "locationContextEnabled";
  static const String supportsApplicationCache = "applicationCacheEnabled";
  static const String supportsBrowserConnection = "browserConnectionEnabled";
  static const String supportsFindingByCss = "cssSelectorsEnabled";
  static const String proxy = "proxy";
  static const String supportsWebStorage = "webStorageEnabled";
  static const String rotatable = "rotatable";
  static const String acceptSslCerts = "acceptSslCerts";
  static const String hasNativeEvents = "nativeEvents";
  static const String unexpectedAlertBehaviour = "unexpectedAlertBehaviour";
  static const String loggingPrefs = "loggingPrefs";
  static const String enableProfiling = "webdriver.logging.profiler.enabled";

  static Map<String, dynamic> get chrome => empty
    ..[browserName] = Browser.chrome
    ..[version] = ''
    ..[platform] = BrowserPlatform.any;

  static Map<String, dynamic> get firefox => empty
    ..[browserName] = Browser.firefox
    ..[version] = ''
    ..[platform] = BrowserPlatform.any;

  static Map<String, dynamic> get android => empty
    ..[browserName] = Browser.android
    ..[version] = ''
    ..[platform] = BrowserPlatform.android;

  static Map<String, dynamic> get empty => new Map<String, dynamic>();
}

class Browser {
  static const String firefox = "firefox";
  static const String firefox2 = "firefox2";
  static const String firefox3 = "firefox3";
  static const String firefoxProxy = "firefoxproxy";
  static const String firefoxChrome = "firefoxchrome";
  static const String googleChrome = "googlechrome";
  static const String safari = "safari";
  static const String opera = "opera";
  static const String iexplore = "iexplore";
  static const String iexploreProxy = "iexploreproxy";
  static const String safariProxy = "safariproxy";
  static const String chrome = "chrome";
  static const String konqueror = "konqueror";
  static const String mock = "mock";
  static const String ieHta = "iehta";
  static const String android = "android";
  static const String htmlUnit = "htmlunit";
  static const String ie = "internet explorer";
  static const String iphone = "iPhone";
  static const String ipad = "iPad";
  static const String phantomJS = "phantomjs";
}

class BrowserPlatform {
  static const String any = "ANY";
  static const String android = "ANDROID";
}

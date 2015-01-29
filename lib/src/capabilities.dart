part of webdriver;

class Capabilities {
  static const String BROWSER_NAME = "browserName";
  static const String PLATFORM = "platform";
  static const String SUPPORTS_JAVASCRIPT = "javascriptEnabled";
  static const String TAKES_SCREENSHOT = "takesScreenshot";
  static const String VERSION = "version";
  static const String SUPPORTS_ALERTS = "handlesAlerts";
  static const String SUPPORTS_SQL_DATABASE = "databaseEnabled";
  static const String SUPPORTS_LOCATION_CONTEXT = "locationContextEnabled";
  static const String SUPPORTS_APPLICATION_CACHE = "applicationCacheEnabled";
  static const String SUPPORTS_BROWSER_CONNECTION = "browserConnectionEnabled";
  static const String SUPPORTS_FINDING_BY_CSS = "cssSelectorsEnabled";
  static const String PROXY = "proxy";
  static const String SUPPORTS_WEB_STORAGE = "webStorageEnabled";
  static const String ROTATABLE = "rotatable";
  static const String ACCEPT_SSL_CERTS = "acceptSslCerts";
  static const String HAS_NATIVE_EVENTS = "nativeEvents";
  static const String UNEXPECTED_ALERT_BEHAVIOUR = "unexpectedAlertBehaviour";
  static const String LOGGING_PREFS = "loggingPrefs";
  static const String ENABLE_PROFILING_CAPABILITY =
      "webdriver.logging.profiler.enabled";

  static Map<String, dynamic> get chrome => empty
    ..[BROWSER_NAME] = Browser.CHROME
    ..[VERSION] = ''
    ..[PLATFORM] = Platform.ANY;

  static Map<String, dynamic> get firefox => empty
    ..[BROWSER_NAME] = Browser.FIREFOX
    ..[VERSION] = ''
    ..[PLATFORM] = Platform.ANY;

  static Map<String, dynamic> get android => empty
    ..[BROWSER_NAME] = Browser.ANDROID
    ..[VERSION] = ''
    ..[PLATFORM] = Platform.ANDROID;

  static Map<String, dynamic> get empty => new Map<String, dynamic>();
}

class Browser {
  static const String FIREFOX = "firefox";
  static const String FIREFOX_2 = "firefox2";
  static const String FIREFOX_3 = "firefox3";
  static const String FIREFOX_PROXY = "firefoxproxy";
  static const String FIREFOX_CHROME = "firefoxchrome";
  static const String GOOGLECHROME = "googlechrome";
  static const String SAFARI = "safari";
  static const String OPERA = "opera";
  static const String IEXPLORE = "iexplore";
  static const String IEXPLORE_PROXY = "iexploreproxy";
  static const String SAFARI_PROXY = "safariproxy";
  static const String CHROME = "chrome";
  static const String KONQUEROR = "konqueror";
  static const String MOCK = "mock";
  static const String IE_HTA = "iehta";
  static const String ANDROID = "android";
  static const String HTMLUNIT = "htmlunit";
  static const String IE = "internet explorer";
  static const String IPHONE = "iPhone";
  static const String IPAD = "iPad";
  static const String PHANTOMJS = "phantomjs";
}

class Platform {
  static const String ANY = "ANY";
  static const String ANDROID = "ANDROID";
}

## v1.2.2

*  Refactor tests.
*  Make project buildable and testable with Bazel.
*  Enable generics for waitFor.

## v1.2.1

* Enable redirects to handle 303 responses from Selenium.

## v1.2.0

* Fix all strong mode errors.

## v1.1.1

* Fix some analyzer warnings.
* `_performRequest` now uses `whenComplete`, not `finally` (#119).


## v1.1.0

* Added `WebDriver.captureScreenshotAsBase64()`, which returns the screenshot as
  a base64-encoded string.
* Added `WebDriver.captureScreenshotAsList()`, which returns the screenshot as
  list of uint8.
* Deprecated `WebDriver.captureScreenshot()` due to bad performance (#114).
  Please use the new screenshot methods instead.
* Removed dependency on crypto package.

Thanks to @blackhc and @xavierhainaux for the contributions.

## v1.0.0

No functional change, just bumping the version number.

## v0.10.0-pre.15

* Add Future-based listeners to `web_driver.dart`.
* Use google.com/ncr to avoid redirect when running outside US
* Add chords support to `keyboard.dart`.
* Add enum for mouse buttons (breaking API change!)

## v0.10.0-pre.14

* Adds support for enabling/disabling listeners to WebDriver.
* Adds `awaitChecking` mode to Lock class.

## v0.10.0-pre.13

* Lots of cleanup and new features.

## v0.10.0-pre.12

* Adds a Stepper interface and StdioStepper which allows control of execution of
  WebDriver commands.

## v0.10.0-pre.11

* Improve exception stack traces.
* Add option to `quit()` to not end the WebDriver session.

## v0.10.0-pre.10

* Minor updates.

## v0.10.0-pre.9

* Adds command listening.

## v0.10.0-pre.8

* Add `support/forwarder.dart`.
* Move `async_helpers.dart` to `support/async.dart`.

## v0.10.0-pre.7

* Fix expect implementation.

## v0.10.0-pre.6

* Fixes to pubspec.
* Added missing copyright notices.

## v0.10.0-pre.4

* Various cleanup.
* Change `captureScreenshot` to return Stream.

## v0.10.0-pre.3

* Rename some methods.
* Add `WebDriver.get()` and remove `WebDriver.navigate.to()`.

## v0.10.0-pre.2

* Added `close()` method to CommandProcessor that gets called by
  `WebDriver.quit()`.
* Ensure that HttpClient in _IOCommandProcessor gets closed.
* Add `fromExistingSession()` functions to allow creation of WebDriver instances
  connected to existing sessions.

## v0.10.0-pre.1

* Isolate HTTP code from the rest of the WebDriver implementation.
* Create support for running WebDriver from inside browser.
* Other cleanup.

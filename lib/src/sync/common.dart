// Copyright 2017 Google Inc. All Rights Reserved.
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

import '../../async_core.dart' as async_core;
import '../../async_io.dart' as async_io;

import 'web_driver.dart';
import 'web_element.dart';

// Magic constants -- identifiers indicating a value is an element.
// Source: https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol
const String jsonWireElementStr = 'ELEMENT';

// Source: https://www.w3.org/TR/webdriver/#elements
const String w3cElementStr = 'element-6066-11e4-a52e-4f735466cecf';

/// Returns an [async_core.WebDriver] with the same URI + session ID.
async_core.WebDriver createAsyncWebDriver(WebDriver driver) =>
    new async_core.WebDriver(new async_io.IOCommandProcessor(), driver.uri,
        driver.id, driver.capabilities);

/// Returns an [async_core.WebElement] based on a current [WebElement].
async_core.WebElement createAsyncWebElement(WebElement element) =>
    new async_core.WebElement(createAsyncWebDriver(element.driver), element.id);

/// Simple class to provide access to indexed properties such as WebElement
/// attributes or css styles.
class Attributes {
  final Resolver _resolver;

  Attributes(driver, command) : _resolver = new Resolver(driver, command);

  String operator [](String name) => _resolver.get(name) as String;
}

abstract class SearchContext {
  WebDriver get driver;

  /// Produces a compatible [async_core.SearchContext]. Allows backwards
  /// compatibility with other frameworks.
  async_core.SearchContext get asyncContext;

  /// Searches for multiple elements within the context.
  List<WebElement> findElements(By by);

  /// Searches for an element within the context.
  ///
  /// Throws [NoSuchElementException] if no matching element is found.
  WebElement findElement(By by);
}

class Resolver {
  final String prefix;
  final WebDriver driver;

  Resolver(this.driver, this.prefix);

  dynamic post(String command, [param]) =>
      driver.postRequest(_resolve(command), param);

  dynamic get(String command) => driver.getRequest(_resolve(command));

  dynamic delete(String command) => driver.deleteRequest(_resolve(command));

  String _resolve(command) {
    if (prefix == null || prefix.isEmpty) {
      return command;
    }
    if (command == null || command.isEmpty) {
      return prefix;
    }
    return '$prefix/$command';
  }
}

class By {
  final String using;
  final String value;

  const By(this.using, this.value);

  /// Returns an element whose ID attribute matches the search value.
  const By.id(String id) : this('id', id);

  /// Returns an element matching an XPath expression.
  const By.xpath(String xpath) : this('xpath', xpath);

  /// Returns an anchor element whose visible text matches the search value.
  const By.linkText(String linkText) : this('link text', linkText);

  /// Returns an anchor element whose visible text partially matches the search
  /// value.
  const By.partialLinkText(String partialLinkText)
      : this('partial link text', partialLinkText);

  /// Returns an element whose NAME attribute matches the search value.
  const By.name(String name) : this('name', name);

  /// Returns an element whose tag name matches the search value.
  const By.tagName(String tagName) : this('tag name', tagName);

  /**
   * Returns an element whose class name contains the search value; compound
   * class names are not permitted
   */
  const By.className(String className) : this('class name', className);

  /// Returns an element matching a CSS selector.
  const By.cssSelector(String cssSelector) : this('css selector', cssSelector);

  @override
  String toString() {
    var constructor;
    switch (using) {
      case 'link text':
        constructor = 'linkText';
        break;
      case 'partial link text':
        constructor = 'partialLinkText';
        break;
      case 'tag name':
        constructor = 'tagName';
        break;
      case 'class name':
        constructor = 'className';
        break;
      case 'css selector':
        constructor = 'cssSelector';
        break;
      default:
        constructor = using;
    }
    return 'By.$constructor($value)';
  }

  @override
  int get hashCode => using.hashCode * 3 + value.hashCode;

  @override
  bool operator ==(other) =>
      other is By && other.using == this.using && other.value == this.value;
}

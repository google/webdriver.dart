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

import 'dart:math' show Point, Rectangle;

import 'element_finder.dart';

import '../common.dart';
import '../web_driver.dart';
import '../web_element.dart';

class W3cWebElement implements WebElement, SearchContext {
  final String _elementPrefix;
  final Resolver _resolver;
  ElementFinder _finder;

  @override
  final String id;

  @override
  final SearchContext context;

  @override
  final WebDriver driver;

  @override
  final dynamic /* String | Finder */ locator;

  @override
  final int index;

  W3cWebElement(this.driver, id, [this.context, this.locator, this.index])
      : this.id = id,
        _elementPrefix = 'element/$id',
        _resolver = new Resolver(driver, 'element/$id') {
    _finder = new ElementFinder(driver, _resolver, this);
  }

  @override
  void click() => _resolver.post('click', {});

  @override
  // TODO(staats): better exception.
  void submit() => throw 'Unsupported by W3c spec';

  @override
  // TODO(staats): tie this into actions API support.
  void sendKeys(String keysToSend) {
    _resolver.post('value', {
      'text': [keysToSend],
      'keyboard': ''
    });
  }

  @override
  void clear() => _resolver.post('clear');

  @override
  bool get selected => _resolver.get('selected') as bool;

  @override
  bool get enabled => _resolver.get('enabled') as bool;

  @override
  // TODO(staats): add many, many tests here.
  bool get displayed {
    final style = _resolver.get('property/getComputedStyle');
    return style['display'] != 'none';
  }

  @override
  // TODO(staats): better exception.
  Point get location => throw 'Unsupported by W3C spec, use "rect" instead.';

  @override
  Rectangle<int> get size =>
      throw 'Unsupported by W3C spec, use "rect" instead.';

  @override
  Rectangle<int> get rect {
    final rect = _resolver.get('rect');
    return new Rectangle(rect['x'].toInt(), rect['y'].toInt(),
        rect['width'].toInt(), rect['height'].toInt());
  }

  @override
  String get name => _resolver.get('name') as String;

  @override
  String get text => _resolver.get('text') as String;

  @override
  WebElement findElement(By by) => _finder.findElement(by);

  @override
  List<WebElement> findElements(By by) => _finder.findElements(by);

  @override
  Attributes get attributes =>
      new Attributes(driver, '$_elementPrefix/attribute');

  @override
  Attributes get cssProperties => new Attributes(driver, '$_elementPrefix/css');

  // TODO(staats): add support for properties to WebElement.

  @override
  bool equals(WebElement other) => _resolver.get('equals/${other.id}') as bool;

  @override
  Map<String, String> toJson() => {jsonWireElementStr: id};

  @override
  int get hashCode => driver.hashCode * 3 + id.hashCode;

  @override
  bool operator ==(other) =>
      other is WebElement && other.driver == this.driver && other.id == this.id;

  @override
  String toString() {
    final out = new StringBuffer()..write(context);
    if (locator is By) {
      if (index == null) {
        out.write('.findElement(');
      } else {
        out.write('.findElements(');
      }
      out..write(locator)..write(')');
    } else {
      out..write('.')..write(locator);
    }
    if (index != null) {
      out..write('[')..write(index)..write(']');
    }
    return out.toString();
  }
}

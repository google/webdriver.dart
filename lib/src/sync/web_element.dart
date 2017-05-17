// Copyright 2015 Google Inc. All Rights Reserved.
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

import 'common.dart';
import 'dart:math' show Point, Rectangle;

class WebElement extends WebDriverBase implements SearchContext {
  final String id;

  /// The context from which this element was found.
  final SearchContext context;

  /// How the element was located from the context.
  final dynamic /* String | Finder */ locator;

  /// The index of this element in the set of element founds. If the method
  /// used to find this element always returns one element, then this is null.
  final int index;

  WebElement(driver, id, [this.context, this.locator, this.index])
      : this.id = id,
        super(driver, 'element/$id');

  /// Click on this element.
  void click() {
    post('click');
  }

  /// Submit this element if it is part of a form.
  void submit() {
    post('submit');
  }

  /// Send [keysToSend] to this element.
  void sendKeys(String keysToSend) {
    post('value', {
      'value': [keysToSend]
    });
  }

  /// Clear the content of a text element.
  void clear() {
    post('clear');
  }

  /// Is this radio button/checkbox selected?
  bool get selected => get('selected') as bool;

  /// Is this form element enabled?
  bool get enabled => get('enabled') as bool;

  /// Is this element visible in the page?
  bool get displayed => get('displayed') as bool;

  /// The location within the document of this element.
  Point get location {
    var point = get('location');
    return new Point<int>(point['x'].toInt(), point['y'].toInt());
  }

  /// The size of this element.
  Rectangle<int> get size {
    var size = get('size');
    return new Rectangle<int>(
        0, 0, size['width'].toInt(), size['height'].toInt());
  }

  /// The tag name for this element.
  String get name => get('name') as String;

  ///  Visible text within this element.
  String get text => get('text') as String;

  ///Find an element nested within this element.
  ///
  /// Throws [NoSuchElementException] if matching element is not found.
  WebElement findElement(By by) {
    var element = post('element', by);
    return new WebElement(driver, element[elementStr], this, by);
  }

  /// Find multiple elements nested within this element.
  List<WebElement> findElements(By by) {
    var elements = post('elements', by) as Iterable;
    int i = 0;
    final webElements = new List<WebElement>();
    for (var element in elements) {
      webElements
          .add(new WebElement(driver, element[elementStr], this, by, i++));
    }
    return webElements;
  }

  /// Access to the HTML attributes of this tag.
  ///
  /// TODO(DrMarcII): consider special handling of boolean attributes.
  Attributes get attributes => new Attributes(driver, '$prefix/attribute');

  /// Access to the cssProperties of this element.
  ///
  /// TODO(DrMarcII): consider special handling of color and possibly other
  /// properties.
  Attributes get cssProperties => new Attributes(driver, '$prefix/css');

  /// Does this element represent the same element as another element?
  /// Not the same as ==
  bool equals(WebElement other) => get('equals/${other.id}') as bool;

  Map<String, String> toJson() => {elementStr: id};

  @override
  int get hashCode => driver.hashCode * 3 + id.hashCode;

  @override
  bool operator ==(other) =>
      other is WebElement && other.driver == this.driver && other.id == this.id;

  @override
  String toString() {
    var out = new StringBuffer()..write(context);
    if (locator is By) {
      if (index == null) {
        out..write('.findElement(');
      } else {
        out..write('.findElements(');
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

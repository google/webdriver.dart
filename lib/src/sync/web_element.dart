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

import 'common.dart';
import 'web_driver.dart';

/// WebDriver representation and interactions with an HTML element.
abstract class WebElement implements SearchContext {
  String get id;

  /// The context from which this element was found.
  SearchContext get context;

  WebDriver get driver;

  /// How the element was located from the context.
  dynamic /* String | Finder */ get locator;

  /// The index of this element in the set of element founds. If the method
  /// used to find this element always returns one element, then this is null.
  int get index;

  /// Click on this element.
  void click();

  /// Submit this element if it is part of a form.
  void submit();

  /// Send [keysToSend] to this element.
  void sendKeys(String keysToSend);

  /// Clear the content of a text element.
  void clear();

  /// Is this radio button/checkbox selected?
  bool get selected;

  /// Is this form element enabled?
  bool get enabled;

  /// Is this element visible in the page?
  bool get displayed;

  /// The location of the element.
  ///
  /// This is assumed to be the upper left corner of the element, but its
  /// implementation is not well defined in the JSON spec.
  @Deprecated('JSON wire legacy support, emulated for newer browsers')
  Point get location;

  /// The size of this element.
  @Deprecated('JSON wire legacy support, emulated for newer browsers')
  Rectangle<int> get size;

  /// The bounds of this element.
  ///
  /// This the W3C spec compatible approach.
  Rectangle<int> get rect;

  /// The tag name for this element.
  String get name;

  ///  Visible text within this element.
  String get text;

  ///Find an element nested within this element.
  ///
  /// Throws [NoSuchElementException] if matching element is not found.
  WebElement findElement(By by);

  /// Find multiple elements nested within this element.
  List<WebElement> findElements(By by);

  /// Access to the HTML attributes of this tag.
  Attributes get attributes;

  /// Access to the cssProperties of this element.
  Attributes get cssProperties;

  /// Are these two elements the same underlying element in the DOM.
  bool equals(WebElement other);

  Map<String, String> toJson();
}

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

library webdriver.target_locator_test;

import 'package:unittest/unittest.dart';
import 'package:webdriver/core.dart';

import '../test_util.dart';

/**
 * Tests for switchTo.frame(). switchTo.window() and switchTo.alert are tested
 * in other classes.
 */
void main() {
  group('TargetLocator', () {
    WebDriver driver;
    WebElement frame;

    setUp(() async {
      driver = await createTestDriver();
      await driver.navigate.to(testPagePath);
      frame = await driver.findElement(new By.name('frame'));
    });

    tearDown(() => driver.quit());

    test('frame index', () async {
      await driver.switchTo.frame(0);
      expect(await driver.pageSource, contains('this is a frame'));
    });

    test('frame name', () async {
      await driver.switchTo.frame('frame');
      expect(await driver.pageSource, contains('this is a frame'));
    });

    test('frame element', () async {
      await driver.switchTo.frame(frame);
      expect(await driver.pageSource, contains('this is a frame'));
    });

    test('root frame', () async {
      await driver.switchTo.frame(frame);
      await driver.switchTo.frame();
      await driver.findElement(new By.tagName('button'));
    });
  });
}

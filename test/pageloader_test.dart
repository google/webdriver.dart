library webdriver_test;

import 'dart:io' as io;
import 'package:webdriver/pageloader.dart';
import 'package:webdriver/webdriver.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';

/**
 * These tests are not expected to be run as part of normal automated testing,
 * as they are slow and they have external dependencies.
 */
main() {
  useVMConfiguration();

  io.File file = new io.File('test_page.html');

  WebDriver driver;
  PageLoader loader;

  setUp(() => WebDriver.createDriver(desiredCapabilities: Capabilities.chrome)
        .then((_driver) {
          driver = _driver;
          loader = new PageLoader(driver);
          return driver.get('file://' + file.fullPathSync());
        }));

  tearDown(() => driver.quit());

  test('simple', () {
    return loader.getInstance(PageForSimpleTest)
        .then((PageForSimpleTest page) {
          expect(page.table.rows, hasLength(2));
          expect(page.table.rows[0].cells, hasLength(2));
          expect(page.table.rows[1].cells, hasLength(2));
          expect(page.table.rows[0].cells[0].text, completion('r1c1'));
          expect(page.table.rows[0].cells[1].text, completion('r1c2'));
          expect(page.table.rows[1].cells[0].text, completion('r2c1'));
          expect(page.table.rows[1].cells[1].text, completion('r2c2'));
        });
  });

  test('displayed filtering', () {
    return loader.getInstance(PageForDisplayedFilteringTest)
        .then((PageForDisplayedFilteringTest page) {
          expect(page.shouldHaveOneElement, hasLength(1));
          expect(page.shouldBeEmpty, isEmpty);
          expect(page.shouldAlsoBeEmpty, isEmpty);
        });
  });

  test('setters', () {
    return loader.getInstance(PageForSettersTest)
        .then((PageForSettersTest page) {
          expect(page._shouldHaveOneElement, hasLength(1));
        });
  });

  test('skip finals', () {
    return loader.getInstance(PageForSkipFinalTest)
        .then((PageForSkipFinalTest page) {
          expect(page.shouldHaveOneElement, hasLength(1));
          expect(page.shouldBeNull, isNull);
        });
  });

  test('skip fields without finders', () {
    return loader.getInstance(PageForSkipFieldsWithoutFinderTest)
        .then((PageForSkipFieldsWithoutFinderTest page) {
          expect(page.shouldHaveOneElement, hasLength(1));
          expect(page.shouldBeNull, isNull);
        });
  });

  test('no matching element', () {
    expect(loader.getInstance(PageForNoMatchingElementTest), throws);
  });

  test('multiple matching element', () {
    expect(loader.getInstance(PageForMultipleMatchingElementTest), throws);
  });

  test('multiple finders', () {
    expect(() => loader.getInstance(PageForMultipleFinderTest), throws);
  });

  test('invalid constructor', () {
    expect(() => loader.getInstance(PageForInvalidConstructorTest), throws);
  });
}

class PageForSimpleTest {
  @By.tagName('table')
  Table table;
}

class Table {
  @By.tagName('tr')
  @ListOf(Row)
  List<Row> rows;
}

class Row {
  @By.tagName('td')
  List<WebElement> cells;
}

class PageForDisplayedFilteringTest {
  @By.id('div') @WithState.present()
  List<WebElement> shouldHaveOneElement;

  @By.id('div')
  List<WebElement> shouldBeEmpty;

  @By.id('div') @WithState.visible()
  @ListOf()
  dynamic shouldAlsoBeEmpty;
}

class PageForSettersTest {
  List<WebElement> _shouldHaveOneElement;

  @By.id('div') @WithState.present()
  set shouldHaveOneElement(List<WebElement> elements) {
    _shouldHaveOneElement = elements;
  }
}

class PageForSkipFinalTest {
  @By.id('div') @WithState.present()
  List<WebElement> shouldHaveOneElement;

  @By.id('div') @WithState.present()
  final List<WebElement> shouldBeNull = null;
}

class PageForSkipFieldsWithoutFinderTest {
  @By.id('div') @WithState.present()
  List<WebElement> shouldHaveOneElement;

  @WithState.present()
  List<WebElement> shouldBeNull;
}

class PageForNoMatchingElementTest {
  @By.id('non-existent id')
  WebElement doesntExist;
}

class PageForMultipleMatchingElementTest {
  @By.tagName('td')
  WebElement doesntExist;
}

class PageForMultipleFinderTest {
  @By.id('non-existent id') @By.name('a-name')
  WebElement multipleFinder;
}

class PageForInvalidConstructorTest {

  PageForInvalidConstructorTest(String someArg);

  @By.id('div') @WithState.present()
  List<WebElement> shouldHaveOneElement;
}

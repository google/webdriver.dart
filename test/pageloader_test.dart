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

  test('simple test', () {
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

  test('displayedFilteringTest', () {
    return loader.getInstance(PageForDisplayedFilteringTest)
        .then((PageForDisplayedFilteringTest page) {
          expect(page.shouldHaveOneElement, hasLength(1));
          expect(page.shouldBeEmpty, isEmpty);
          expect(page.shouldAlsoBeEmpty, isEmpty);
        });
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
  @ListOf()
  List<WebElement> cells;
}

class PageForDisplayedFilteringTest {
  @By.id('div') @WithState.present()
  @ListOf()
  List<WebElement> shouldHaveOneElement;

  @By.id('div')
  @ListOf()
  List<WebElement> shouldBeEmpty;

  @By.id('div') @WithState.visible()
  @ListOf()
  List<WebElement> shouldAlsoBeEmpty;
}
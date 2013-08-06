library pageloader;

import 'dart:async';
import 'dart:mirrors';

import 'package:meta/meta.dart';

import 'webdriver.dart';

class PageLoader {
  WebDriver _driver;

  PageLoader(this._driver);

  Future getInstance(Type type) =>
      _getInstance(reflectClass(type), _driver);

  Future _getInstance(ClassMirror type, SearchContext context) {
    var fieldFutures = new List<Future>();
    var instance = _reflectedInstance(type);

    for (VariableMirror field in type.variables.values) {
      var fieldInfo = new FieldInfo(field);
      if (fieldInfo != null) {
        fieldFutures.add(fieldInfo.setField(instance, context, this));
      }
    }

    return Future.wait(fieldFutures).then((_) => instance.reflectee);
  }

  InstanceMirror _reflectedInstance(ClassMirror aClass) {
    InstanceMirror page;

    for (MethodMirror constructor in aClass.constructors.values) {
      if (constructor.parameters.isEmpty) {
        page = aClass.newInstance(constructor.constructorName, []);
        break;
      }
    }

    if (page == null) {
      throw new StateError('$aClass has no acceptable constructors');
    }
    return page;
  }
}

// Hack because I can't figure out how to get the full type for fields.
class ListOf {
  final Type type;

  const ListOf([this.type = WebElement]);
}

abstract class FilterFinder {
  const FilterFinder();

  List<FilterFinderOption> get options => [];
}

abstract class Finder extends FilterFinder {
  const Finder();

  Future<List<WebElement>> findElements(SearchContext context);
}

abstract class Filter extends FilterFinder {

  const Filter();

  Future<List<WebElement>> filter(List<WebElement> elements);
}

abstract class ElementFilter extends Filter {

  const ElementFilter();

  Future<List<WebElement>> filter(List<WebElement> elements) =>
      Future.wait(elements.map(keep))
        .then((keeps) {
          var i = 0;
          var newElements = new List<WebElement>();
          for (var keep in keeps) {
            if (keep) {
              newElements.add(elements[i]);
            }
            i++;
          }
          return newElements;
        });

  Future<bool> keep(WebElement element);
}

class IsDisplayed extends ElementFilter {

  final bool _displayed;

  const IsDisplayed([this._displayed = true]);

  Future<bool> keep(WebElement element) =>
      element.displayed.then((displayed) => displayed == _displayed);

  List<FilterFinderOption> get options =>
      [ FilterFinderOption.DISABLE_IMPLICIT_DISPLAY_FILTERING ];
}

class ByFinder extends Finder {
  final By _by;

  ByFinder(this._by);

  @override
  Future<WebElement> findElement(SearchContext context) {
    return context.findElement(_by);
  }

  @override
  Future<List<WebElement>> findElements(SearchContext context) {
    return context.findElements(_by);
  }
}

class FilterFinderOption {
  final String option;

  const FilterFinderOption._(this.option);

  static const FilterFinderOption DISABLE_IMPLICIT_DISPLAY_FILTERING =
      const FilterFinderOption._('DISABLE_IMPLICIT_DISPLAY_FILTERING');

}

class FieldInfo {
  final Symbol _fieldName;
  final Finder _finder;
  final List<Filter> _filters;
  final TypeMirror _instanceType;
  final bool _isList;

  factory FieldInfo(VariableMirror field) {
    var finder;
    var filters = new List<Filter>();
    var type = field.type;

    var isList = false;

    var implicitDisplayFiltering = true;

    for (InstanceMirror metadatum in field.metadata) {
      if (!metadatum.hasReflectee) {
        continue;
      }
      var datum = metadatum.reflectee;

      if (datum is By) {
        if (finder != null) {
          throw new StateError('Cannot have multiple finders on field');
        }
        finder = new ByFinder(datum);
      } else if (datum is Finder) {
        if (finder != null) {
          throw new StateError('Cannot have multiple finders on field');
        }
        finder = datum;
      } else if (datum is Filter) {
        filters.add(datum);
      } else if (datum is ListOf) {
        isList = true;
        type = reflectClass(datum.type);
      }

      if (datum is FilterFinder &&
          datum.options.contains(
              FilterFinderOption.DISABLE_IMPLICIT_DISPLAY_FILTERING)) {
        implicitDisplayFiltering = false;
      }

      if (type.simpleName == new Symbol('dynamic')) {
        type = reflectClass(WebElement);
      }
    }

    if (implicitDisplayFiltering) {
      filters.insert(0, new IsDisplayed());
    }

    if (finder != null) {
      return new FieldInfo._(field.simpleName, finder, filters, type, isList);
    } else {
      return null;
    }
  }

  FieldInfo._(
      this._fieldName,
      this._finder,
      this._filters,
      this._instanceType,
      this._isList);

  Future setField(
      InstanceMirror instance,
      SearchContext context,
      PageLoader loader) {
    var future = _getElements(context);

    print(instance.reflectee);

    if (_instanceType.simpleName != new Symbol('WebElement')) {
      future = future.then((elements) =>
          Future.wait(elements.map((element) =>
              loader._getInstance(_instanceType, element))));
    }

    if (_isList) {
      return future.then((objects) =>
          instance.setField(_fieldName, objects));
    } else {
      return future.then((objects) =>
          instance.setField(_fieldName, objects.first));
    }
  }

  Future<List<WebElement>> _getElements(SearchContext context) {
    var future = _finder.findElements(context);
    for (var filter in _filters) {
      future = future.then(filter.filter);
    }
    if (!_isList) {
      future.then((elements) => elements.take(1));
    }
    return future;
  }
}
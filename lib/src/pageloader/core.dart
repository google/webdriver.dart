part of pageloader;

/**
 * Mechanism for specifying hierarchical page objects using annotations on
 * fields in simple Dart objects.
 */
class PageLoader {
  final WebDriver _driver;

  PageLoader(this._driver);

  /**
   * Creates a new instance of type and binds annotated fields to corresponding
   * elements.
   */
  Future getInstance(Type type) =>
      _getInstance(reflectClass(type), _driver);

  Future _getInstance(ClassMirror type, SearchContext context) {
    var fieldFutures = [];
    var instance = _reflectedInstance(type);

    for (VariableMirror field in type.variables.values) {
      var fieldInfo = new _FieldInfo(field);
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

class _FieldInfo {
  final Symbol _fieldName;
  final Finder _finder;
  final List<Filter> _filters;
  final TypeMirror _instanceType;
  final bool _isList;

  factory _FieldInfo(VariableMirror field) {
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
        finder = new _ByFinder(datum);
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

      if (datum is _FilterFinder &&
          datum.options.contains(
              FilterFinderOption.DISABLE_IMPLICIT_DISPLAY_FILTERING)) {
        implicitDisplayFiltering = false;
      }

      if (type.simpleName == const Symbol('dynamic')) {
        type = reflectClass(WebElement);
      }
    }

    if (implicitDisplayFiltering) {
      filters.insert(0, new WithState.visible());
    }

    if (finder != null) {
      return new _FieldInfo._(field.simpleName, finder, filters, type, isList);
    } else {
      return null;
    }
  }

  _FieldInfo._(
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

    if (_instanceType.simpleName != const Symbol('WebElement')) {
      future = future.then((elements) =>
          Future.wait(elements.map((element) =>
              loader._getInstance(_instanceType, element))));
    }

    if (_isList) {
      return future.then((objects) =>
          instance.setField(_fieldName, objects));
    } else {
      return future.then((objects) {
        if (objects.length != 1) {
          throw new StateError('multiple or no elements found for field');
        }
        return instance.setField(_fieldName, objects.first);
      });
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

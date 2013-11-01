part of pageloader;

/**
 * Mechanism for specifying hierarchical page objects using annotations on
 * fields in simple Dart objects.
 */
class PageLoader {
  final WebDriver _driver;

  PageLoader(this._driver);

  /**
   * Creates a new instance of [type] and binds annotated fields to
   * corresponding [WebElement]s.
   */
  Future getInstance(Type type) =>
      _getInstance(reflectClass(type), _driver);

  Future _getInstance(ClassMirror type, SearchContext context) {
    var fieldInfos = _fieldInfos(type);
    var instance = _reflectedInstance(type);

    var fieldFutures = fieldInfos.map((info) =>
        info.setField(instance, context, this));

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

  Iterable<_FieldInfo> _fieldInfos(ClassMirror type) {
    var infos = <_FieldInfo>[];

    while (type != null) {
      for (DeclarationMirror decl in type.declarations.values) {
        _FieldInfo info = new _FieldInfo(_driver, decl);
        if (info != null) {
          infos.add(info);
        }
      }
      type = type.superclass;
    }

    return infos;
  }
}

class _FieldInfo {
  final WebDriver _driver;
  final Symbol _fieldName;
  final Finder _finder;
  final List<Filter> _filters;
  final TypeMirror _instanceType;
  final bool _isList;

  factory _FieldInfo(WebDriver driver, DeclarationMirror field) {
    var finder;
    var filters = new List<Filter>();
    var type;
    var name;

    if (field is VariableMirror && !field.isFinal) {
      type = field.type;
      name = field.simpleName;
    } else if (field is MethodMirror && field.isSetter) {
      type = field.parameters.first.type;
      // HACK to get correct symbol name for operating with setField.
      name = field.simpleName.toString();
      name = new Symbol(name.substring(8, name.length - 3));
    } else {
      return null;
    }

    var isList = false;

    if (type.simpleName == const Symbol('List')) {
      isList = true;
      type = null;
    }

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
        if (type != null && type.simpleName != const Symbol('dynamic')) {
          throw new StateError('Field type is not compatible with ListOf');
        }
        isList = true;
        type = reflectClass(datum.type);
      }

      if (datum is _FilterFinder &&
          datum.options.contains(
              FilterFinderOption.DISABLE_IMPLICIT_DISPLAY_FILTERING)) {
        implicitDisplayFiltering = false;
      }
    }

    if (type == null || type.simpleName == const Symbol('dynamic')) {
      type = reflectClass(WebElement);
    }

    if (implicitDisplayFiltering) {
      filters.insert(0, new WithState.visible());
    }

    if (finder != null) {
      return new _FieldInfo._(driver, name, finder, filters, type, isList);
    } else {
      return null;
    }
  }

  _FieldInfo._(
      this._driver,
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

    if (!_isList) {
      future = future.then((objects) => objects.first);
    }

    return future.then((value) => instance.setField(_fieldName, value));
  }

  Future<List<WebElement>> _getElements(SearchContext context) {
    var future = _finder.findElements(_driver, context);
    for (var filter in _filters) {
      future = future.then(filter.filter);
    }
    if (!_isList) {
      future = future.then((elements) {
        if (elements.length != 1) {
          throw new StateError('multiple or no elements found for field');
        }
        return elements.take(1);
      });
    }
    return future;
  }
}

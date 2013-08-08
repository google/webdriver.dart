part of pageloader;

/**
 * Annotate a field as representing a List of some type. If type is
 * not supplied, defaults to WebElement.
 */
// Hack because I can't figure out how to get the full type for fields.
class ListOf {
  final Type type;

  const ListOf([this.type = WebElement]);
}

///Finders identify an initial set of WebElements to be used for a field.
abstract class Finder extends _FilterFinder {
  const Finder();

  /// returns the List<WebElement> that should be considered for a field.
  Future<List<WebElement>> findElements(SearchContext context);
}

/// Filters reduce the set of elements to be used for a field.
abstract class Filter extends _FilterFinder {

  const Filter();

  /// Returns a subset of elements that should be kept for a field.
  Future<List<WebElement>> filter(List<WebElement> elements);
}

/**
 * Convenience class for Filters that only need information about a specific
 * element to determine whether to keep it or not.
 */
abstract class ElementFilter extends Filter {

  const ElementFilter();

  @override
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

  /// Return true if you want include this element.
  Future<bool> keep(WebElement element);
}

abstract class _FilterFinder {
  const _FilterFinder();

  /**
   * Returns a set of FilterFinderOptions that control the behavior of this
   * Filter or Finder.
   */
  List<FilterFinderOption> get options => const [];
}

/**
 * Filter that keeps elements based on their visibility. Overrides the
 * default visibility filter used by PageLoader.
 */
class WithState extends ElementFilter {

  final _displayed;

  const WithState._(this._displayed);

  /// Keep all elements regardless of whether they are visible or not.
  const WithState.present() : this._(null);

  /**
   * Keep only elements that are visible. This is the default for PageLoader
   * so should generally not be necessary.
   */
  const WithState.visible() : this._(true);

  /// Keep only elements that are invisible.
  const WithState.invisible() : this._(false);

  @override
  Future<bool> keep(WebElement element) {
    if (_displayed == null) {
      return new Future.value(true);
    } else {
      return element.displayed.then((displayed) => displayed == _displayed);
    }
  }

  @override
  List<FilterFinderOption> get options =>
      const [ FilterFinderOption.DISABLE_IMPLICIT_DISPLAY_FILTERING ];
}

/**
 * Matches the root WebElement being used for constructing the current page
 * object.
 */
class Root extends Finder {
  const Root();

  @override
  Future<List<WebElement>> findElements(SearchContext context) {
    if (context is WebElement) {
      return new Future.value([ context ]);
    } else {
      return context.findElements(const By.xpath('/*'));
    }
  }

  @override
  List<FilterFinderOption> get options =>
      const [ FilterFinderOption.DISABLE_IMPLICIT_DISPLAY_FILTERING ];
}

/**
 * Keeps only elements that have the given attribute with the given value.
 */
class WithAttribute extends ElementFilter {

  final String name;
  final String value;

  /**
   * @param value String or null if checking for the absence of an attribute.
   */
  const WithAttribute(this.name, this.value);

  @override
  Future<bool> keep(WebElement element) => element.attributes[name]
      .then((attribute) => attribute == value);
}

class _ByFinder extends Finder {
  final By _by;

  const _ByFinder(this._by);

  @override
  Future<List<WebElement>> findElements(SearchContext context) {
    return context.findElements(_by);
  }
}

/// Enum of options for that can be returned by _FilterFinder.options.
class FilterFinderOption {
  final String option;

  const FilterFinderOption._(this.option);

  /// Disable the default implicit display filtering for a field.
  static const FilterFinderOption DISABLE_IMPLICIT_DISPLAY_FILTERING =
      const FilterFinderOption._('DISABLE_IMPLICIT_DISPLAY_FILTERING');
}

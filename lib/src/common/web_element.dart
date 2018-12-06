/// Common interface for web element, containing only the element id.
abstract class WebElement {
  String get id;

  Map<String, String> toJson() => {'ELEMENT': id};
}

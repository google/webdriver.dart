
import 'dart:mirrors';

class MyClass {
  @ListOf(String)
  var myField;
}

class ListOf {
  final Type type;

  const ListOf(this.type);
}

void main() {
  print(reflectClass(MyClass).variables.values.first.type);
}
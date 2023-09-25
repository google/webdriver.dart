class TimeoutValues {
  final Duration script;
  final Duration implicit;
  final Duration pageLoad;

  TimeoutValues(
      {required this.script, required this.implicit, required this.pageLoad});

  @override
  String toString() =>
      'TimeoutValues(script: $script, implicit: $implicit, pageLoad: $pageLoad)';

  @override
  int get hashCode => Object.hashAll([script, implicit, pageLoad]);

  @override
  bool operator ==(Object other) =>
      other is TimeoutValues &&
      script == other.script &&
      implicit == other.implicit &&
      pageLoad == other.pageLoad;
}

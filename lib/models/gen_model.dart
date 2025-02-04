class GenModel {
  final String variable;
  final String path;

  GenModel({required this.variable, required this.path});

  @override
  String toString() =>
      '- Variable: $variable\n- Path: $path\n--------------------------------------';
}

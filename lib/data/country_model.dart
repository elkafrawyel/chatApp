class CountryModel {
  String name, code, flag;

  CountryModel({this.name, this.code, this.flag});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryModel &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() {
    return name;
  }
}

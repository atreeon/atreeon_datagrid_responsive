abstract class FilterField {
  bool get isSet;
  FilterField clear();
}

class FilterFieldString implements FilterField {
  final String? searchText;
  final eStringFilterType stringFilterType;

  FilterFieldString({this.searchText, this.stringFilterType = eStringFilterType.contains});

  bool get isSet {
    return searchText != null && searchText!.isNotEmpty;
  }

  @override
  FilterFieldString clear() {
    return FilterFieldString();
  }
}

class FilterFieldNum implements FilterField {
  final num? filter1;
  final num? filter2;
  final eNumFilterType numFilterType;

  FilterFieldNum({this.filter1, this.filter2, this.numFilterType = eNumFilterType.equals});

  @override
  FilterFieldNum clear() {
    return FilterFieldNum();
  }

  bool get isSet => this.filter1 != null || this.filter2 != null;
}

enum eStringFilterType with DropdownEnum {
  contains(0, eSearchFieldType.oneField, "contains"),
  startsWith(1, eSearchFieldType.oneField, "starts w/"),
  endsWith(2, eSearchFieldType.oneField, "ends w/"),
  equals(3, eSearchFieldType.oneField, "equals");

  const eStringFilterType(
    this.number,
    this.searchFieldType,
    this.description,
  );

  final int number;
  final eSearchFieldType searchFieldType;
  final String description;
}

enum eNumFilterType with DropdownEnum {
  contains(0, eSearchFieldType.oneField, "contains"),
  equals(1, eSearchFieldType.oneField, "equals"),
  gt(2, eSearchFieldType.oneField, "gt"),
  lt(2, eSearchFieldType.oneField, "lt"),
  between(3, eSearchFieldType.twoFields, "between");

  const eNumFilterType(
    this.number,
    this.searchFieldType,
    this.description,
  );

  final int number;
  final eSearchFieldType searchFieldType;
  final String description;
}

mixin DropdownEnum {
  int get number;

  eSearchFieldType get searchFieldType;

  String get description;
}

enum eSearchFieldType { oneField, twoFields }

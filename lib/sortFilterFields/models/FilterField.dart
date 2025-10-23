/// The sealed filter field hierarchy exposes the contract shared by every filterable input.
sealed class FilterField {
  const FilterField();

  /// Indicates whether the filter currently holds any user supplied criteria.
  bool get isSet;

  /// Returns a copy of the filter with all values cleared.
  FilterField clear();
}

/// Captures text based filter configuration, including the raw query and comparison mode.
final class FilterFieldString extends FilterField {
  /// The optional text to find within the field value.
  final String? searchText;

  /// Controls how the supplied [searchText] should be interpreted when filtering.
  final eStringFilterType stringFilterType;

  /// Creates a filter that operates on string data.
  const FilterFieldString({this.searchText, this.stringFilterType = eStringFilterType.contains});

  @override
  bool get isSet => searchText != null && searchText!.isNotEmpty;

  @override
  FilterFieldString clear() => const FilterFieldString();
}

/// Captures numeric filter configuration including optional boundary values.
final class FilterFieldNum extends FilterField {
  /// Optional lower bound (or single value) constraint.
  final num? filter1;

  /// Optional upper bound constraint used by [eNumFilterType.between].
  final num? filter2;

  final eNumFilterType numFilterType;

  /// Creates a filter that operates on numeric values.
  const FilterFieldNum({this.filter1, this.filter2, this.numFilterType = eNumFilterType.equals});

  @override
  // codex: Express the null safe check for whether either boundary was provided.
  /// Reports whether at least one numeric bound has been defined.
  bool get isSet => filter1 != null || filter2 != null;

  @override
  FilterFieldNum clear() => const FilterFieldNum();
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

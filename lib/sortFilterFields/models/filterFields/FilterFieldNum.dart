part of filter_field_models;

/// {@template filter_field_num}
/// Captures numeric filter configuration including optional boundary values.
/// {@endtemplate}
final class FilterFieldNum extends FilterField {
  /// {@macro filter_field_num}
  const FilterFieldNum({this.filter1, this.filter2, this.numFilterType = eNumFilterType.equals});

  /// Optional lower bound (or single value) constraint.
  final num? filter1;

  /// Optional upper bound constraint used by [eNumFilterType.between].
  final num? filter2;

  /// Identifies how the numeric values should be compared during filtering.
  final eNumFilterType numFilterType;

  /// Reports whether at least one numeric bound has been defined.
  @override
  bool get isSet => filter1 != null || filter2 != null;

  /// Produces an empty numeric filter using the default equality comparison.
  @override
  FilterFieldNum clear() => const FilterFieldNum();
}

/// Expresses the comparison operators available to [FilterFieldNum].
enum eNumFilterType with DropdownEnum {
  /// Matches numeric values whose string representation contains the query.
  contains(0, eSearchFieldType.oneField, "contains"),

  /// Matches numeric values equal to the provided bound.
  equals(1, eSearchFieldType.oneField, "equals"),

  /// Matches numeric values greater than the provided bound.
  gt(2, eSearchFieldType.oneField, "gt"),

  /// Matches numeric values less than the provided bound.
  lt(2, eSearchFieldType.oneField, "lt"),

  /// Matches numeric values inside the provided inclusive range.
  between(3, eSearchFieldType.twoFields, "between");

  /// Configures a numeric comparison operator with UI hints.
  const eNumFilterType(
    this.number,
    this.searchFieldType,
    this.description,
  );

  /// Machine readable numeric id used by dropdown menus.
  final int number;

  /// Determines how many editors the UI should render for this comparison.
  final eSearchFieldType searchFieldType;

  /// User facing description presented in dropdown menus.
  final String description;
}

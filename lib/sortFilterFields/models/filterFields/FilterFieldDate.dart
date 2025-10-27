part of filter_field_models;

/// {@template filter_field_date}
/// Captures date based filter configuration including comparison semantics and boundaries.
/// {@endtemplate}
final class FilterFieldDate extends FilterField {
  /// {@macro filter_field_date}
  const FilterFieldDate({this.filter1, this.filter2, this.dateFilterType = eDateFilterType.equals});

  /// Primary date operand used by modes other than [eDateFilterType.between].
  final DateTime? filter1;

  /// Secondary date operand used when [dateFilterType] equals [eDateFilterType.between].
  final DateTime? filter2;

  /// Identifies the comparison strategy for the selected date field.
  final eDateFilterType dateFilterType;

  /// Reports whether any relevant date operand has been supplied.
  @override
  bool get isSet {
    var result = switch (dateFilterType) {
      eDateFilterType.between => filter1 != null || filter2 != null,
      _ => filter1 != null,
    };
    return result;
  }

  /// Produces an empty date filter using the default equality comparison.
  @override
  FilterFieldDate clear() => const FilterFieldDate();
}

/// Expresses the comparison operators available to [FilterFieldDate].
enum eDateFilterType with DropdownEnum {
  /// Matches records whose field value equals [FilterFieldDate.filter1].
  equals(0, eSearchFieldType.oneField, "equals"),

  /// Matches records whose field value is strictly greater than [FilterFieldDate.filter1].
  gt(1, eSearchFieldType.oneField, "gt"),

  /// Matches records whose field value is strictly less than [FilterFieldDate.filter1].
  lt(2, eSearchFieldType.oneField, "lt"),

  /// Matches records whose field value sits inside the inclusive range defined by both filters.
  between(3, eSearchFieldType.twoFields, "between");

  /// Configures a date comparison operator with UI hints.
  const eDateFilterType(
    this.number,
    this.searchFieldType,
    this.description,
  );

  /// Machine readable numeric id used by dropdown menus.
  final int number;

  /// Determines how many date editors the UI should surface for the mode.
  final eSearchFieldType searchFieldType;

  /// User facing description rendered in filter editors.
  final String description;
}

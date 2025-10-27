part of filter_field_models;

/// {@template filter_field_string}
/// Captures text based filter configuration, including the raw query and comparison mode.
/// {@endtemplate}
final class FilterFieldString extends FilterField {
  /// {@macro filter_field_string}
  const FilterFieldString({this.searchText, this.stringFilterType = eStringFilterType.contains});

  /// The optional text to find within the field value.
  final String? searchText;

  /// Controls how the supplied [searchText] should be interpreted when filtering.
  final eStringFilterType stringFilterType;

  /// Reports whether a non empty search string has been provided.
  @override
  bool get isSet => searchText != null && searchText!.isNotEmpty;

  /// Produces an empty string filter with default comparison mode.
  @override
  FilterFieldString clear() => const FilterFieldString();
}

/// Lists the matching strategies offered by [FilterFieldString].
enum eStringFilterType with DropdownEnum {
  /// Performs a substring case insensitive match against the field value.
  contains(0, eSearchFieldType.oneField, "contains"),

  /// Matches entries starting with the provided query.
  startsWith(1, eSearchFieldType.oneField, "starts w/"),

  /// Matches entries ending with the provided query.
  endsWith(2, eSearchFieldType.oneField, "ends w/"),

  /// Performs an exact match on the raw value.
  equals(3, eSearchFieldType.oneField, "equals");

  /// Configures a string filter comparison mode.
  const eStringFilterType(
    this.number,
    this.searchFieldType,
    this.description,
  );

  /// Machine readable numeric id used by dropdown menus.
  final int number;

  /// Determines how many editors the UI should surface for the mode.
  final eSearchFieldType searchFieldType;

  /// User facing label rendered in filter editors.
  final String description;
}

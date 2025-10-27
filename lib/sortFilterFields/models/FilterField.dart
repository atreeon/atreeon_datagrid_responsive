library filter_field_models;

part 'filterFields/FilterFieldString.dart';
part 'filterFields/FilterFieldNum.dart';
part 'filterFields/FilterFieldDate.dart';

/// The sealed filter field hierarchy exposes the contract shared by every filterable input.
sealed class FilterField {
  const FilterField();

  /// Indicates whether the filter currently holds any user supplied criteria.
  bool get isSet;

  /// Returns a copy of the filter with all values cleared.
  FilterField clear();
}

/// shared contract for dropdown enum metadata consumed by editors.
mixin DropdownEnum {
  int get number;

  eSearchFieldType get searchFieldType;

  String get description;
}

/// Describes the number of input fields a filter editor should render.
enum eSearchFieldType { oneField, twoFields }

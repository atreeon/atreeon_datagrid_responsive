import 'package:atreeon_datagrid_responsive/sortFilterFields/models/FilterField.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/SortField.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/fn_fieldDef.dart';

class Field<T> {
  final fn_fieldDef<T> fieldDefinition;
  final fn_fieldDef<T>? fieldDefForSortFilter;
  final String labelId;
  final SortField? sort;
  final FilterField? filter;
  final String Function(T)? format;

  Field(
    this.fieldDefinition,
    this.labelId,
    this.filter, {
    this.sort,
    this.fieldDefForSortFilter,
    this.format,
    // this.width,
  });

  Field<T> copyWithSort(SortField? sort) {
    return Field(
      this.fieldDefinition,
      this.labelId,
      this.filter,
      sort: sort,
      fieldDefForSortFilter: this.fieldDefForSortFilter,
      format: this.format,
      // width: this.width,
    );
  }

  Field<T> copyWithFilter(FilterField? filter) {
    return Field(
      this.fieldDefinition,
      this.labelId,
      filter,
      sort: this.sort,
      fieldDefForSortFilter: this.fieldDefForSortFilter,
      format: this.format,
      // width: this.width,
    );
  }
}

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

class SortField {
  final bool isAscending;

  SortField({
    this.isAscending = true,
  });
}

abstract class FilterField {
  bool get isSet;
}

enum eSearchFieldType { oneField, twoFields }

mixin DropdownEnum {
  int get number;

  eSearchFieldType get searchFieldType;

  String get description;
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

class FilterFieldString implements FilterField {
  final String? searchText;
  final eStringFilterType stringFilterType;

  FilterFieldString({this.searchText, this.stringFilterType = eStringFilterType.contains});

  bool get isSet => searchText != null;
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

class FilterFieldNum implements FilterField {
  final num? filter1;
  final num? filter2;
  final eNumFilterType numFilterType;

  FilterFieldNum({this.filter1, this.filter2, this.numFilterType = eNumFilterType.equals});

  bool get isSet => this.filter1 != null || this.filter2 != null;
}

typedef fn_fieldDef<T> = Comparable? Function(T);

/////get function to get the properties of Item
//Comparable? getField(String propertyName, SortFilterable sortable) {
//  var _mapRep = sortable.sortFilterFields();
//  var result = _mapRep[propertyName];
//
//  return result;
//}

//
//typedef SortFilterFields_fn<T> = Map<String, Comparable?> Function(T);
//
//class SortFilterableItem<T> {
//  final T item;
//  final SortFilterFields_fn<T> sortFilterFields;
//
//  SortFilterableItem(this.item, this.sortFilterFields);
//
//  Comparable? getField(String propertyName) {
//    var _mapRep = sortFilterFields(this.item);
//    var result = _mapRep[propertyName];
//
//    return result;
//  }
//
//  String toString() => item.toString();
//}
//
//class DataTypeNotSupportedException implements Exception {
//  final String message;
//
//  DataTypeNotSupportedException(this.message);
//}

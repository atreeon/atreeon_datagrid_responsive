library atreeon_datagrid_responsive;

import 'package:diacritic/diacritic.dart';

import 'common.dart';

//class SortField {
//  final String fieldName;
//  final bool isAscending;
//
//  SortField(this.fieldName, {this.isAscending = true});
//}

//class Field2_String<T> {
//  final String Function(T) fieldDefinition;
//  final String label;
//  final SortField2? sort;
//
//  Field2_String(this.fieldDefinition, this.label, {this.sort});
//}

extension MultiSort<T> on Iterable<T> {
  Iterable<T> multisort(List<Field<T>> sortedFields) {
    if (sortedFields.length == 0) //
      return this;

    int compare(fn_fieldDef<T> fieldDef, SortField sort, T a, T b) {
      var valueA = fieldDef(a);
      var valueB = fieldDef(b);

      if (valueA == null && valueB == null) //
        return 0;

      if (valueA == null) //
        return 1;

      if (valueB == null) //
        return -1;

      int result;
      if (valueA is String && valueB is String) {
        var valA = removeDiacritics(valueA);
        var valB = removeDiacritics(valueB);
        result = valA.toUpperCase().compareTo(valB.toUpperCase());
      } else //
        result = valueA.compareTo(valueB);

      if (!sort.isAscending) //
        return result * -1;

      return result;
    }

    int sortall(T a, T b) {
      int i = 0;
      int? result;

      var sortedFields2 = sortedFields.where((element) => element.sort != null).toList();

      while (i < sortedFields2.length) {
        var field = sortedFields2[i];

        result = compare(field.fieldDefinition, field.sort!, a, b);

        if (result != 0) //
          break;
        i++;
      }
      return result ?? 0;
    }

    final list = this.toList();

    list.sort((a, b) => sortall(a, b));

    return list;
  }
}

library atreeon_datagrid_responsive;

import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/SortField.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/fn_fieldDef.dart';
import 'package:diacritic/diacritic.dart';

extension MultiSort<T> on Iterable<T> {
  Iterable<T> multisort(List<Field<T>> sortedFields) {
    if (sortedFields.isEmpty) //
      return this;

    int compare(fn_fieldDef<T> fieldDef, SortField sort, T a, T b) {
      // Evaluate both comparable values once so the switch expression can inspect them.
      final (valueA, valueB) = (fieldDef(a), fieldDef(b));

      // Use a switch expression to exhaustively handle every combination of null, string and comparable values.
      final comparison = switch ((valueA, valueB)) {
        (null, null) => 0,
        (null, _) => 1,
        (_, null) => -1,
        (String valA, String valB) => removeDiacritics(valA).toUpperCase().compareTo(removeDiacritics(valB).toUpperCase()),
        (Comparable<Object?> valA, Comparable<Object?> valB) => valA.compareTo(valB),
      };

      // Apply the requested sort direction by inverting the result when descending.
      return sort.isAscending ? comparison : -comparison;
    }

    int sortall(T a, T b) {
      int i = 0;
      int? result;

      // Materialise the filtered sort fields once for reuse within the comparator.
      final sortedFields2 = sortedFields.where((element) => element.sort != null).toList();

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

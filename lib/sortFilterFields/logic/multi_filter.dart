library multi_filter;

import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/FilterField.dart';
import 'package:diacritic/diacritic.dart';

extension MultiSort<T> on Iterable<T> {
  Iterable<T> multiFilter(List<Field<T>> fields) {
    final filteredFields = fields.where((element) => element.filter?.isSet ?? false).toList();

    if (filteredFields.isEmpty) //
      return this;

    final list = where((item) {
      var result = true;

      for (final filteredField in filteredFields) {
        final fieldResolver = filteredField.fieldDefForSortFilter ?? filteredField.fieldDefinition;

        final value = fieldResolver(item);

        final filter = filteredField.filter;

        if (filter == null || !filter.isSet) {
          continue;
        }

        if (value == null) {
          result = false;
          continue;
        }

        switch ((filter, value)) {
          case (FilterFieldString(searchText: final text?, stringFilterType: final mode), String stringValue) when text.trim().isNotEmpty:
            final normalisedValue = removeDiacritics(stringValue).toLowerCase();

            final normalisedSearch = removeDiacritics(text).toLowerCase();

            final matches = switch (mode) {
              eStringFilterType.equals => normalisedValue == normalisedSearch,
              eStringFilterType.contains => normalisedValue.contains(normalisedSearch),
              eStringFilterType.startsWith => normalisedValue.startsWith(normalisedSearch),
              eStringFilterType.endsWith => normalisedValue.endsWith(normalisedSearch),
            };

            result = matches && result;

          case (FilterFieldNum(filter1: final primary, filter2: final secondary, numFilterType: final mode), num numericValue):
            final matches = switch (mode) {
              eNumFilterType.equals => primary == null || numericValue == primary,
              eNumFilterType.contains => primary == null || numericValue.toString().toLowerCase().contains(primary.toString().toLowerCase()),
              eNumFilterType.gt => primary == null ? true : numericValue > primary,
              eNumFilterType.lt => primary == null ? true : numericValue < primary,
              eNumFilterType.between => numericValue >= (primary ?? -2e53) && numericValue <= (secondary ?? 2e53),
            };

            result = matches && result;

          default:
            break;
        }

        if (!result) {
          break;
        }
      }

      return result;
    }).toList();

    return list;
  }
}

library multi_filter;

import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/FilterField.dart';
import 'package:diacritic/diacritic.dart';

extension MultiSort<T> on Iterable<T> {
  Iterable<T> multiFilter(List<Field<T>> fields) {
    var filteredFields = fields.where((element) => element.filter!.isSet).toList();

    if (filteredFields.length == 0) //
      return this;

    var list = this.where((item) {
      var result = true;

      for (var i = 0; i < filteredFields.length; ++i) {
        var filteredField = filteredFields[i];

        var value = filteredField.fieldDefForSortFilter == null //
            ? filteredField.fieldDefinition(item)
            : filteredField.fieldDefForSortFilter!(item);

        var filter = filteredField.filter!;

        //can't filter for nulls
        if (value == null) {
          result = false;
        } else {
          if (filter is FilterFieldString && value is String && filter.isSet) {
            var _value = removeDiacritics(value);
            var searchText = removeDiacritics(filter.searchText!);

            if (searchText.trim() != "") {
              if (filter.stringFilterType == eStringFilterType.equals) {
                result = _value.toLowerCase() == searchText.toLowerCase() && result;
              } else if (filter.stringFilterType == eStringFilterType.contains) {
                result = _value.toLowerCase().contains(searchText.toLowerCase()) && result;
              } else if (filter.stringFilterType == eStringFilterType.startsWith) {
                result = _value.toLowerCase().startsWith(searchText.toLowerCase()) && result;
                // print("'${_value.toLowerCase()}' '${searchText.toLowerCase()}' $result");
              } else if (filter.stringFilterType == eStringFilterType.endsWith) {
                result = _value.toLowerCase().endsWith(searchText.toLowerCase()) && result;
              } else {
                throw Exception("unexpected eStringFilterType");
              }
            }
          }

          if (filter is FilterFieldNum && value is num && filter.isSet) {
            if (filter.numFilterType == eNumFilterType.equals) {
              result = filter.filter1 == null || value == filter.filter1 && result;
            } else if (filter.numFilterType == eNumFilterType.contains) {
              result = filter.filter1 == null || value.toString().toLowerCase().contains(filter.filter1.toString().toLowerCase()) && result;
            } else if (filter.numFilterType == eNumFilterType.gt) {
              result = filter.filter1 == null || value > filter.filter1! && result;
            } else if (filter.numFilterType == eNumFilterType.lt) {
              result = filter.filter1 == null || value < filter.filter1! && result;
            } else if (filter.numFilterType == eNumFilterType.between) {
              var from = filter.filter1 ?? -2e53;
              var to = filter.filter2 ?? 2e53;
              result = (value >= from && value <= to) && result;
            } else {
              throw Exception("unexpected eStringFilterType");
            }
          }
        }
      }

      return result;
    }).toList();

    return list;
  }
}

//think this is old code

//abstract class Filterable {}

//abstract class FilterField {
//  final String fieldName;
//
//  FilterField(this.fieldName);
//}

//class FilterFieldString implements FilterField {
//  final String fieldName;
//  final String? searchText;
//
//  FilterFieldString({required this.fieldName, this.searchText});
//}

//class FilterFieldNum implements FilterField {
//  final String fieldName;
//  final num? from;
//  final num? to;
//  final num? singleNumber;
//
//  FilterFieldNum({
//    required this.fieldName,
//    required this.from,
//    required this.to,
//    required this.singleNumber,
//  });
//}

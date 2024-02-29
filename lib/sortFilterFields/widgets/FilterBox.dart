import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/FilterField.dart';
import 'package:flutter/material.dart';

/// {@template [FilterBox]}
/// A filter to go with multi-filter to enable filtering of a list.
/// If nothing is passed into the search string it will not be searched
/// {@endtemplate}
///
/// {@macro [labelId]}
class FilterBox<T> extends StatefulWidget {
  /// The current list of filtered fields
  final List<Field<T>> fields;

  ///{@macro [labelId]}
  final String labelId;

  final void Function(List<Field<T>>) onChange;

  final double fontSize;

  ///{@macro [FilterBox]}
  ///
  ///{@macro [labelId]}
  FilterBox(
    this.fields,
    this.labelId,
    this.onChange,
    this.fontSize, {
    super.key,
  });

  _FilterBoxState createState() => _FilterBoxState<T>();
}

class _FilterBoxState<T> extends State<FilterBox<T>> {
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  late Field<T> thisField;
  late DropdownEnum dropdownSelection;

  void initState() {
    thisField = widget.fields.firstWhere((e) => e.labelId == widget.labelId);
    var thisFilter = thisField.filter;

    if (thisFilter is FilterFieldString) {
      controller1.text = thisFilter.searchText ?? "";
      dropdownSelection = thisFilter.stringFilterType;
    }

    if (thisFilter is FilterFieldNum) {
      controller1.text = thisFilter.filter1 == null ? "" : thisFilter.filter1.toString();
      controller2.text = thisFilter.filter2 == null ? "" : thisFilter.filter2.toString();
      dropdownSelection = thisFilter.numFilterType;
    }

    controller1.addListener(onFilterChangeListener);
    controller2.addListener(onFilterChangeListener);

    super.initState();
  }

  onFilterChangeListener() {
    var newFields = widget.fields.map((e) {
      if (e.labelId == widget.labelId) {
        var eFilter = e.filter;
        if (eFilter is FilterFieldString) {
          return e.copyWithFilter(FilterFieldString(
            searchText: controller1.text,
            stringFilterType: dropdownSelection as eStringFilterType,
          ));
        } else if (eFilter is FilterFieldNum) {
          return e.copyWithFilter(
            FilterFieldNum(
              filter1: controller1.text != '' ? num.parse(controller1.text) : null,
              filter2: controller2.text != '' ? num.parse(controller2.text) : null,
              numFilterType: dropdownSelection as eNumFilterType,
            ),
          );
        }
        throw UnimplementedError();
      } else
        return e;
    }).toList();

    widget.onChange(newFields);
  }

  int getFilterValue(FilterField? filter) {
    if (filter is FilterFieldString) {
      return filter.stringFilterType.index;
    } else if (filter is FilterFieldNum) {
      return filter.numFilterType.index;
    } else {
      throw Exception("unexpected filter");
    }
  }

  List<DropdownMenuItem<DropdownEnum>> getDropdownItems(FilterField? filter) {
    var items = () {
      if (filter is FilterFieldString) {
        // ignore: unnecessary_cast
        return eStringFilterType.values as List<DropdownEnum>;
      } else if (filter is FilterFieldNum) {
        // ignore: unnecessary_cast
        return eNumFilterType.values as List<DropdownEnum>;
      } else {
        throw Exception("unexpected filter");
      }
    }();

    return items
        .map((e) => DropdownMenuItem<DropdownEnum>(
              value: e,
              child: Text(e.description),
            ))
        .toList();
  }

  Widget build(BuildContext context) {
    var keyboardType = thisField.filter is FilterFieldNum //
        ? TextInputType.number
        : TextInputType.text;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<DropdownEnum>(
          isDense: true,
          value: this.dropdownSelection,
          style: TextStyle(color: Colors.grey, fontSize: widget.fontSize),
          onChanged: (DropdownEnum? value) {
            if (value == null) {
              return;
            }

            setState(() {
              this.controller1.text = "";
              this.controller2.text = "";
              this.dropdownSelection = value;
            });
            onFilterChangeListener();
          },
          items: getDropdownItems(thisField.filter),
        ),
        if (this.dropdownSelection.searchFieldType == eSearchFieldType.oneField)
          Container(
            width: 150,
            child: TextField(
              controller: controller1,
              keyboardType: keyboardType,
              decoration: const InputDecoration(
                isDense: true,
              ),
              style: TextStyle(fontSize: widget.fontSize),
            ),
          ),
        if (this.dropdownSelection.searchFieldType == eSearchFieldType.twoFields)
          Row(
            children: [
              Container(
                width: 75,
                child: TextField(
                  controller: controller1,
                  keyboardType: keyboardType,
                  decoration: const InputDecoration(
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: widget.fontSize),
                ),
              ),
              Container(
                width: 5,
              ),
              Container(
                width: 75,
                child: TextField(
                  controller: controller2,
                  keyboardType: keyboardType,
                  decoration: const InputDecoration(
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: widget.fontSize),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

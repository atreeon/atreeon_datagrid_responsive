import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

class DataGridRowsDTS<T> extends DataTableSource {
  final List<T> data;
  final List<Field<T>> fields;
  final void Function(T, List<String>)? onRowClick;
  final Field<T>? identityField;
  final List<String> selectedIds;
  final void Function(List<String>) onSelected;
  final List<String>? Function(List<String>)? onCheckboxChange;
  final bool Function(List<String>)? onCheckRequirement;
  final double fontSize;

  DataGridRowsDTS(
    this.data,
    this.fields,
    this.onRowClick,
    this.identityField,
    this.selectedIds,
    this.onSelected, {
    required this.fontSize,
    this.onCheckboxChange,
    this.onCheckRequirement,
  });

  List<DataRow> getAllRows() {
    return data.mapIndexed((i, e) => getRow(i)).toList();
  }

  DataRow getRow(int i) {
    //need to remove this duplication
    return DataRow.byIndex(
      onSelectChanged: (x) {
        if (onRowClick != null) //
          onRowClick?.call(data[i], selectedIds);

        var id = identityField!.fieldDefinition(data[i])!;

        if (selectedIds.contains(id.toString())) {
          //remove
          var selected = selectedIds //
              .where((element) => element != id.toString())
              .toList();
          var selection3 = onCheckboxChange?.call(selected) ?? selected;
          onSelected(selection3);
        } else {
          //add
          if (onCheckRequirement != null && !onCheckRequirement!(selectedIds)) //
            return;

          var newSelection = [...selectedIds, id.toString()];
          var selection3 = onCheckboxChange?.call(newSelection) ?? newSelection;
          onSelected(selection3);
        }
      },
      index: i,
      cells: [
        ...fields
            .map(
              (e) => DataCell(
                SingleChildScrollView(
                  scrollDirection: Axis.vertical, //.horizontal
                  child: Text(
                    e.format != null ? e.format!(data[i]) : e.fieldDefinition(data[i]).toString(),
                    style: TextStyle(fontSize: this.fontSize),
                  ),
                ),
              ),
            )
            .toList(),
        if (identityField != null) //
          DataCell(
            Checkbox(
              value: selectedIds.contains(identityField!.fieldDefinition(data[i]).toString()),
              onChanged: (x) {
                var id = identityField!.fieldDefinition(data[i])!;

                if (selectedIds.contains(id.toString())) {
                  var selected = selectedIds //
                      .where((element) => element != id.toString())
                      .toList();
                  var selection3 = onCheckboxChange?.call(selected) ?? selected;
                  onSelected(selection3);
                } else {
                  if (onCheckRequirement != null && !onCheckRequirement!(selectedIds)) //
                    return;

                  var newSelection = [...selectedIds, id.toString()];
                  var selection3 = onCheckboxChange?.call(newSelection) ?? newSelection;
                  onSelected(selection3);
                }
              },
            ),
          ),
      ],
    );
  }

  int get rowCount => data.length;

  bool get isRowCountApproximate => false;

  int get selectedRowCount => 0;
}

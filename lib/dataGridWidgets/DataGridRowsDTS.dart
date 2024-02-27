import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

class DataGridRowsDTS<T> extends DataTableSource {
  final List<T> data;
  final List<Field<T>> fields;
  final void Function(T)? onRowClick;
  final Field<T>? identityField;
  final List<String> selectedIds;
  final void Function(List<String>) onSelected;
  final void Function(List<String>)? onCheckboxChange;
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
  });

  List<DataRow> getAllRows() {
    return data.mapIndexed((i, e) => getRow(i)).toList();
  }

  DataRow getRow(int i) {
    return DataRow.byIndex(
      onSelectChanged: (x) {
        onRowClick?.call(data[i]);
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
                var selected = selectedIds //
                    .where((element) => element != id)
                    .toList();
                var newSelection = [
                  ...selected.except([id.toString()]),
                  if (x != null && x == true) //
                    id.toString(),
                ];

                onCheckboxChange?.call(newSelection);

                onSelected(newSelection);
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

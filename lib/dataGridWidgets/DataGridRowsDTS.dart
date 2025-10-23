import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

class DataGridRowsDTS<T> extends DataTableSource {
  final List<T> data;
  final List<Field<T>> fields;
  final void Function(T, List<String>)? onRowClick;
  final Field<T>? identityField;
  final List<String> selectedIds;

  ///Notify listeners of the new selection when an item is added.
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
    return DataRow.byIndex(
      onSelectChanged: (x) {
        if (onRowClick != null) //
          onRowClick?.call(data[i], selectedIds);

        final id = identityField!.fieldDefinition(data[i])!.toString();
        _toggleSelection(id);
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
                final id = identityField!.fieldDefinition(data[i])!.toString();
                _toggleSelection(id);
              },
            ),
          ),
      ],
    );
  }

  int get rowCount => data.length;

  bool get isRowCountApproximate => false;

  int get selectedRowCount => 0;

  /// Toggles the selection state for the row identified by [id] and notifies listeners.
  void _toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      final updatedSelection = selectedIds.where((element) => element != id).toList();
      final normalizedSelection = onCheckboxChange?.call(updatedSelection) ?? updatedSelection;
      onSelected(normalizedSelection);
      return;
    }

    if (onCheckRequirement != null && !onCheckRequirement!(selectedIds)) //
      return;

    // Build the new selection that includes the provided identifier.
    final updatedSelection = [...selectedIds, id];
    // Allow checkbox hooks to transform the addition before notifying listeners.
    final normalizedSelection = onCheckboxChange?.call(updatedSelection) ?? updatedSelection;
    onSelected(normalizedSelection);
  }
}

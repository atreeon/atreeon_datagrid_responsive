import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

class DataGridRowsDTS<T> extends DataTableSource {
  // codex: Store the records rendered by the grid so each row can be built deterministically.
  final List<T> data;
  // codex: Track the column definitions so cells know how to extract and format values.
  final List<Field<T>> fields;
  // codex: Callback invoked when a user taps a row to propagate selection externally.
  final void Function(T, List<String>)? onRowClick;
  // codex: Identity field used to uniquely tag each row for checkbox selection.
  final Field<T>? identityField;
  // codex: Current list of selected identifiers so checkboxes render in sync.
  final List<String> selectedIds;

  ///Notify listeners of the new selection when an item is added.
  final void Function(List<String>) onSelected;
  // codex: Hook allowing callers to veto or transform selection changes.
  final List<String>? Function(List<String>)? onCheckboxChange;
  // codex: Predicate that can block selection when constraints are not met.
  final bool Function(List<String>)? onCheckRequirement;
  // codex: Base font size applied to all cells for consistent typography.
  final double fontSize;
  // codex: Optional per-column width constraints so cells align with header sizing.
  final List<double?>? columnWidths;
  // codex: Optional width constraint for the trailing selection column.
  final double? selectionColumnWidth;

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
    // codex: Accept width constraints to enforce ellipsis against header-sized columns.
    this.columnWidths,
    // codex: Accept an optional width for the selection column so it mirrors the header.
    this.selectionColumnWidth,
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
        // codex: Iterate with index so we can align each cell with its matching width constraint.
        ...fields
            .mapIndexed(
              (index, e) => DataCell(
                // codex: Constrain the cell to the calculated column width so content ellipsizes before widening the table.
                ConstrainedBox(
                  // codex: Apply the provided per-column width or allow natural sizing when absent.
                  constraints: BoxConstraints(maxWidth: columnWidths != null && index < columnWidths!.length ? columnWidths![index] ?? double.infinity : double.infinity),
                  // codex: Retain the scroll wrapper so tall content can overflow vertically without affecting layout.
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical, //.horizontal
                    child: Text(
                      e.format != null ? e.format!(data[i]) : e.fieldDefinition(data[i]).toString(),
                      // codex: Force a single line so text truncates instead of wrapping and expanding the column.
                      maxLines: 1,
                      // codex: Disable wrapping to allow ellipsis rendering.
                      softWrap: false,
                      // codex: Replace overflowed text with an ellipsis to keep all columns visible.
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: this.fontSize),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
        if (identityField != null) //
          DataCell(
            // codex: Constrain the checkbox column to align with the header width.
            ConstrainedBox(
              // codex: Apply the optional selection column width while allowing natural sizing when null.
              constraints: BoxConstraints(maxWidth: selectionColumnWidth ?? double.infinity),
              child: Checkbox(
                value: selectedIds.contains(identityField!.fieldDefinition(data[i]).toString()),
                onChanged: (x) {
                  final id = identityField!.fieldDefinition(data[i])!.toString();
                  _toggleSelection(id);
                },
              ),
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

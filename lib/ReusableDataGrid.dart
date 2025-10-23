import 'dart:math' as math;

import 'package:atreeon_datagrid_responsive/dataGridWidgets/DataGridRowsDTS.dart';
import 'package:atreeon_datagrid_responsive/dataGridWidgets/FlexibleFixedHeightW.dart';
import 'package:atreeon_datagrid_responsive/dataGridWidgets/atreeon_paginated_data_table.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/SortableFilterableContainerW.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_get_child_size/atreeon_get_child_size.dart';
import 'package:flutter/material.dart';

import 'sortFilterFields/logic/multi_filter.dart';
import 'sortFilterFields/logic/multi_sort.dart';

/// {@template reusable_data_grid}
/// A responsive data grid widget that coordinates filtering, sorting, and
/// pagination for arbitrary row data.
///
/// The grid exposes filter and sort buttons through
/// [SortableFilterableContainerW] instances that mutate the provided [fields].
/// {@endtemplate}
class ReusableDataGrid<T> extends StatefulWidget {
  /// The data set that will be rendered into the grid.
  final List<T> data;

  /// The field definitions that describe columns, sorting, and filtering logic.
  final List<Field<T>> fields;

  /// The fixed height for each data row in logical pixels.
  final double rowHeight;

  /// The height for the table header area in logical pixels.
  final double headerHeight;

  /// The height for the table footer area in logical pixels.
  final double footerHeight;

  /// Callback invoked when a row is tapped.
  final void Function(T, List<String>)? onRowClick;

  /// Callback invoked when the optional "create" button is pressed.
  final void Function()? onCreateClick;

  /// Timestamp used to trigger a refresh when external data updates are saved.
  final DateTime? lastSaveDate;

  /// Field definition that resolves each row's unique identifier.
  final Field<T>? identityFieldId;

  /// Callback for a header-level selection button.
  final void Function(List<String>)? onSelectHeaderButton;

  /// Callback for selection toggles. Returning `null` cancels the change.
  final List<String>? Function(List<String>)? onCheckboxChange;

  /// Predicate that determines whether a selection action is allowed.
  final bool Function(List<String>)? onCheckRequirement;

  /// Localized label used for the select-all header column.
  final String selectName;

  /// Pre-selected row identifiers.
  final List<T>? selectedIds;

  /// Optional maximum height for the grid before paging is enforced.
  final double? maxHeight;

  /// Base font size for textual content within the grid.
  final double fontSize;

  /// Horizontal spacing between columns.
  final double columnSpacing;

  /// Padding applied to the left and right edges of the table.
  final double horizontalMargin;

  /// {@macro reusable_data_grid}
  const ReusableDataGrid({
    super.key,
    required this.data,
    required this.fields,
    required this.lastSaveDate,
    required this.headerHeight,
    required this.footerHeight,
    this.onRowClick,
    this.onCreateClick,
    this.rowHeight = 30,
    this.identityFieldId,
    this.onSelectHeaderButton,
    this.selectName = 'select',
    this.selectedIds,
    this.onCheckboxChange,
    this.onCheckRequirement,
    this.maxHeight,
    this.fontSize = 12,
    this.columnSpacing = 10,
    this.horizontalMargin = 10,
  });

  @override
  State<ReusableDataGrid<T>> createState() => _ReusableDataGridState<T>();
}

class _ReusableDataGridState<T> extends State<ReusableDataGrid<T>> {
  /// The number of rows that can be displayed per page.
  int rowsPerPage = 100;

  /// The excess height when the available space does not evenly divide rows.
  double remainderHeight = 0.0;

  /// Cached widget dimensions used when recalculating layout parameters.
  Size widgetSize = const Size(100, 400);

  /// Cached identifiers for rows currently marked as selected.
  List<String> selectedIds = <String>[];

  /// Effective height cap applied when [ReusableDataGrid.maxHeight] is set.
  late double? maxHeight;

  /// Cached row height read from the widget configuration.
  late double rowHeight;

  /// Cached field definitions used for sorting and filtering.
  late List<Field<T>> fields;

  /// Cached data set with filters and sorts applied.
  late Iterable<T> data;

  /// Indicates when a constrained max height requires rendering the static [DataTable] variant.
  bool get _shouldUseStaticTable => widget.maxHeight != null && maxHeight != widget.maxHeight;

  /// Applies filters, sorts, and selection state based on the latest widget
  /// configuration.
  void _init() {
    rowHeight = widget.rowHeight;
    fields = widget.fields;
    maxHeight = widget.maxHeight;
    data = widget.data.multiFilter(fields).multisort(fields);
    onSizeChange(widgetSize);

    if (widget.selectedIds != null && widget.identityFieldId != null) {
      selectedIds = widget.selectedIds!.map((entry) => widget.identityFieldId!.fieldDefinition(entry).toString()).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant ReusableDataGrid<T> oldWidget) {
    if (widget.lastSaveDate != oldWidget.lastSaveDate || widget.data.length != oldWidget.data.length) {
      _init();
      selectedIds = <String>[];
    }

    super.didUpdateWidget(oldWidget);
  }

  /// Updates the field configuration and recalculates filtered data.
  void setFields(List<Field<T>> updatedFields) {
    setState(() {
      fields = updatedFields;
      data = widget.data.multiFilter(fields).multisort(fields);
    });
  }

  /// Requests a layout recalculation when filters expand or collapse.
  void toggleFilter() {
    onSizeChange(widgetSize);
  }

  /// Adjusts pagination metrics when the measured size of the grid changes.
  void onSizeChange(Size size) {
    setState(() {
      if (maxHeight == null) {
        // Clamp the dynamically computed rows per page so short viewports still render at least one row.
        rowsPerPage = math.max(1, size.height ~/ rowHeight - 2);
        widgetSize = size;
      } else {
        final rowsHeight = widget.maxHeight! - widget.footerHeight - widget.headerHeight;
        // Guarantee a positive page size when constrained by max height to avoid divide-by-zero errors and layout collapse.
        rowsPerPage = math.max(1, rowsHeight ~/ rowHeight);
        final padding = (widget.footerHeight + widget.headerHeight + 2) / rowsPerPage;
        remainderHeight = widget.maxHeight! - (rowsPerPage * (rowHeight + padding));

        if (data.length <= rowsPerPage) {
          rowsPerPage = data.length;
          maxHeight = (rowsPerPage * rowHeight) + rowHeight;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Text('no data');
    }

    final columns = [
      ...widget.fields
          .map(
            (field) => DataColumn(
              label: SortableFilterableW(
                fields: fields,
                labelId: field.labelId,
                onPressed: setFields,
                onChanged: setFields,
                fontSize: widget.fontSize,
              ),
            ),
          )
          .toList(),
      if (widget.identityFieldId != null && widget.onSelectHeaderButton != null)
        DataColumn(
          label: InkWell(
            child: Text(
              widget.selectName,
              style: TextStyle(fontSize: widget.fontSize, decoration: TextDecoration.underline),
            ),
            onTap: () => widget.onSelectHeaderButton!(selectedIds),
          ),
        ),
    ];

    final dataSource = DataGridRowsDTS(
      data.toList(),
      widget.fields,
      widget.onRowClick,
      widget.identityFieldId,
      selectedIds,
      (entries) => setState(() => selectedIds = entries),
      fontSize: widget.fontSize,
      onCheckboxChange: widget.onCheckboxChange,
      onCheckRequirement: widget.onCheckRequirement,
    );

    return FlexibleFixedHeightW(
      height: maxHeight,
      child: GetChildSize(
        onChange: onSizeChange,
        child: Stack(
          children: [
            if (_shouldUseStaticTable)
              Container(
                decoration: const BoxDecoration(),
                child: DataTable(
                  columnSpacing: widget.columnSpacing,
                  horizontalMargin: widget.horizontalMargin,
                  dividerThickness: 0,
                  showCheckboxColumn: false,
                  dataRowMaxHeight: rowHeight,
                  dataRowMinHeight: rowHeight,
                  rows: dataSource.getAllRows(),
                  headingRowHeight: widget.headerHeight + remainderHeight,
                  columns: columns,
                ),
              )
            else
              Container(
                decoration: const BoxDecoration(),
                child: SingleChildScrollView(
                  child: AtreeonPaginatedDataTable(
                    columnSpacing: widget.columnSpacing,
                    horizontalMargin: widget.horizontalMargin,
                    showCheckboxColumn: false,
                    showFirstLastButtons: true,
                    dataRowHeight: rowHeight,
                    source: dataSource,
                    headingRowHeight: widget.headerHeight + (remainderHeight / 2),
                    columns: columns,
                    rowsPerPage: rowsPerPage,
                    fontSize: widget.fontSize,
                    iconSize: 20,
                    footerHeight: widget.footerHeight + (remainderHeight / 2),
                  ),
                ),
              ),
            if (widget.onCreateClick != null)
              Align(
                alignment: Alignment.bottomLeft,
                child: ElevatedButton(
                  onPressed: widget.onCreateClick,
                  child: const Text('CREATE NEW'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

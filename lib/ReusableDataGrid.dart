import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'reusable_data_grid/bloc/reusable_data_grid_bloc.dart';
import 'reusable_data_grid/bloc/reusable_data_grid_event.dart';
import 'reusable_data_grid/view/reusable_data_grid_view.dart';

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

  /// Determines whether column headers always display a filter button instead of relying on long press.
  final bool alwaysShowFilter;

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
    this.alwaysShowFilter = false,
  });

  @override
  State<ReusableDataGrid<T>> createState() => _ReusableDataGridState<T>();
}

class _ReusableDataGridState<T> extends State<ReusableDataGrid<T>> {
  // Maintain the bloc instance so widget rebuilds reuse the same controller.
  late final ReusableDataGridBloc<T> _bloc;

  @override
  void initState() {
    super.initState();
    // Initialize the bloc with the initial widget props so the grid state is ready before build runs.
    _bloc = ReusableDataGridBloc<T>(
      data: widget.data,
      fields: widget.fields,
      identityField: widget.identityFieldId,
      selectedRecords: widget.selectedIds,
      maxHeight: widget.maxHeight,
      rowHeight: widget.rowHeight,
      headerHeight: widget.headerHeight,
      footerHeight: widget.footerHeight,
      lastSaveDate: widget.lastSaveDate,
    );
  }

  @override
  void didUpdateWidget(covariant ReusableDataGrid<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Determine when upstream changes require clearing the local selection to mirror prior behavior.
    final shouldClearSelection = widget.lastSaveDate != oldWidget.lastSaveDate || widget.data.length != oldWidget.data.length;
    // Notify the bloc about new props so filters, data, and layout can update reactively.
    _bloc.add(
      ReusableDataGridConfigurationChanged<T>(
        data: widget.data,
        fields: widget.fields,
        identityField: widget.identityFieldId,
        selectedRecords: widget.selectedIds,
        maxHeight: widget.maxHeight,
        rowHeight: widget.rowHeight,
        headerHeight: widget.headerHeight,
        footerHeight: widget.footerHeight,
        lastSaveDate: widget.lastSaveDate,
        clearSelection: shouldClearSelection,
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provide the existing bloc instance to descendants so UI builders can subscribe to state changes.
    return BlocProvider<ReusableDataGridBloc<T>>.value(
      value: _bloc,
      // Delegate the rendering to the stateless view that consumes bloc state.
      child: ReusableDataGridView<T>(
        onRowClick: widget.onRowClick,
        onCreateClick: widget.onCreateClick,
        identityFieldId: widget.identityFieldId,
        onSelectHeaderButton: widget.onSelectHeaderButton,
        selectName: widget.selectName,
        onCheckboxChange: widget.onCheckboxChange,
        onCheckRequirement: widget.onCheckRequirement,
        fontSize: widget.fontSize,
        columnSpacing: widget.columnSpacing,
        horizontalMargin: widget.horizontalMargin,
        alwaysShowFilter: widget.alwaysShowFilter,
      ),
    );
  }
}

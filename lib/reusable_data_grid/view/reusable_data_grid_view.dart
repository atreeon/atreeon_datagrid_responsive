import 'package:atreeon_datagrid_responsive/dataGridWidgets/DataGridRowsDTS.dart';
import 'package:atreeon_datagrid_responsive/dataGridWidgets/FlexibleFixedHeightW.dart';
import 'package:atreeon_datagrid_responsive/dataGridWidgets/atreeon_paginated_data_table.dart';
import 'package:atreeon_datagrid_responsive/reusable_data_grid/bloc/reusable_data_grid_bloc.dart';
import 'package:atreeon_datagrid_responsive/reusable_data_grid/bloc/reusable_data_grid_event.dart';
import 'package:atreeon_datagrid_responsive/reusable_data_grid/bloc/reusable_data_grid_state.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/SortableFilterableContainerW.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_get_child_size/atreeon_get_child_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template reusable_data_grid_view}
/// Stateless widget that consumes the [ReusableDataGridBloc] and renders rows.
/// {@endtemplate}
class ReusableDataGridView<T> extends StatelessWidget {
  /// Callback invoked when a row is tapped.
  final void Function(T, List<String>)? onRowClick;

  /// Callback invoked when the optional "create" button is pressed.
  final VoidCallback? onCreateClick;

  /// Field definition that resolves each row's unique identifier.
  final Field<T>? identityFieldId;

  /// Callback for a header-level selection button.
  final void Function(List<String>)? onSelectHeaderButton;

  /// Localized label used for the select-all header column.
  final String selectName;

  /// Callback for selection toggles. Returning `null` cancels the change.
  final List<String>? Function(List<String>)? onCheckboxChange;

  /// Predicate that determines whether a selection action is allowed.
  final bool Function(List<String>)? onCheckRequirement;

  /// Base font size for textual content within the grid.
  final double fontSize;

  /// Horizontal spacing between columns.
  final double columnSpacing;

  /// Padding applied to the left and right edges of the table.
  final double horizontalMargin;

  /// Creates a new view for rendering grid rows based on the bloc state.
  const ReusableDataGridView({
    super.key,
    required this.onRowClick,
    required this.onCreateClick,
    required this.identityFieldId,
    required this.onSelectHeaderButton,
    required this.selectName,
    required this.onCheckboxChange,
    required this.onCheckRequirement,
    required this.fontSize,
    required this.columnSpacing,
    required this.horizontalMargin,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReusableDataGridBloc<T>, ReusableDataGridState<T>>(
      builder: (context, state) {
        if (state.data.isEmpty) {
          return const Text('no data');
        }

        final shouldUseStaticTable = state.requestedMaxHeight != null && state.effectiveMaxHeight != state.requestedMaxHeight;

        final fields = state.fields;
        final columns = [
          ...fields
              .map(
                (field) => DataColumn(
                  label: SortableFilterableW(
                    fields: fields,
                    labelId: field.labelId,
                    onPressed: (updated) => _dispatchFields(context, updated),
                    onChanged: (updated) => _dispatchFields(context, updated),
                    fontSize: fontSize,
                  ),
                ),
              )
              .toList(),
          if (identityFieldId != null && onSelectHeaderButton != null)
            DataColumn(
              label: InkWell(
                child: Text(
                  selectName,
                  style: TextStyle(
                    fontSize: fontSize,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () => onSelectHeaderButton!(state.selectedIds),
              ),
            ),
        ];

        final dataSource = DataGridRowsDTS(
          state.data,
          fields,
          onRowClick,
          identityFieldId,
          state.selectedIds,
          (entries) => _dispatchSelection(context, entries),
          fontSize: fontSize,
          onCheckboxChange: onCheckboxChange,
          onCheckRequirement: onCheckRequirement,
        );

        return FlexibleFixedHeightW(
          height: state.effectiveMaxHeight,
          child: GetChildSize(
            onChange: (size) => context.read<ReusableDataGridBloc<T>>().add(
              ReusableDataGridSizeChanged<T>(size: size),
            ),
            child: Stack(
              children: [
                if (shouldUseStaticTable)
                  Container(
                    decoration: const BoxDecoration(),
                    child: DataTable(
                      columnSpacing: columnSpacing,
                      horizontalMargin: horizontalMargin,
                      dividerThickness: 0,
                      showCheckboxColumn: false,
                      dataRowMaxHeight: state.rowHeight,
                      dataRowMinHeight: state.rowHeight,
                      rows: dataSource.getAllRows(),
                      headingRowHeight: state.headerHeight + state.remainderHeight,
                      columns: columns,
                    ),
                  )
                else
                  Container(
                    decoration: const BoxDecoration(),
                    child: SingleChildScrollView(
                      child: AtreeonPaginatedDataTable(
                        columnSpacing: columnSpacing,
                        horizontalMargin: horizontalMargin,
                        showCheckboxColumn: false,
                        showFirstLastButtons: true,
                        dataRowHeight: state.rowHeight,
                        source: dataSource,
                        headingRowHeight: state.headerHeight + (state.remainderHeight / 2),
                        columns: columns,
                        rowsPerPage: state.rowsPerPage,
                        fontSize: fontSize,
                        iconSize: 20,
                        footerHeight: state.footerHeight + (state.remainderHeight / 2),
                      ),
                    ),
                  ),
                if (onCreateClick != null)
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                      onPressed: onCreateClick,
                      child: const Text('CREATE NEW'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Dispatches an event with updated field definitions to the bloc.
  void _dispatchFields(BuildContext context, List<Field<T>> updatedFields) {
    context.read<ReusableDataGridBloc<T>>().add(
      ReusableDataGridFieldsUpdated<T>(fields: updatedFields),
    );
  }

  /// Dispatches the replacement selection list to the bloc.
  void _dispatchSelection(BuildContext context, List<String> selectedIds) {
    context.read<ReusableDataGridBloc<T>>().add(
      ReusableDataGridSelectionReplaced<T>(selectedIds: selectedIds),
    );
  }
}

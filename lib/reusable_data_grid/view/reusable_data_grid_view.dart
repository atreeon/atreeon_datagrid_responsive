import 'package:atreeon_datagrid_responsive/dataGridWidgets/DataGridRowsDTS.dart';
import 'package:atreeon_datagrid_responsive/dataGridWidgets/FlexibleFixedHeightW.dart';
import 'package:atreeon_datagrid_responsive/dataGridWidgets/atreeon_paginated_data_table.dart';
import 'package:atreeon_datagrid_responsive/reusable_data_grid/bloc/reusable_data_grid_bloc.dart';
import 'package:atreeon_datagrid_responsive/reusable_data_grid/bloc/reusable_data_grid_event.dart';
import 'package:atreeon_datagrid_responsive/reusable_data_grid/bloc/reusable_data_grid_state.dart';
import 'package:atreeon_datagrid_responsive/reusable_data_grid/view/column_width_plan.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/SortableFilterableContainerW.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_get_child_size/atreeon_get_child_size.dart';
import 'package:atreeon_datagrid_responsive/theme/data_grid_header_theme.dart';
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

  /// Controls if column headers should always display the filter button.
  final bool alwaysShowFilter;

  /// Indicates whether header sort toggles should leave column order intact.
  final bool preserveFieldOrderOnSort;

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
    this.alwaysShowFilter = false,
    this.preserveFieldOrderOnSort = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReusableDataGridBloc<T>, ReusableDataGridState<T>>(
      builder: (context, state) {
        if (state.data.isEmpty) {
          return const Text('no data');
        }

        final shouldUseStaticTable = state.requestedMaxHeight != null && state.effectiveMaxHeight != state.requestedMaxHeight;

        // Pull header sizing from the theme so we can switch between regular and large header
        final headerTheme = context.dgHeaderTheme;
        final textScaler = MediaQuery.textScalerOf(context);
        final effectiveHeaderStyle = headerTheme.titleStyle.copyWith(
          fontSize: textScaler.scale(headerTheme.titleStyle.fontSize ?? 14),
        );
        final fields = state.fields;
        // codex: Track whether the trailing selection column should be rendered so width allocation accounts for it.
        // codex: Flag whether the Clear column should render so width planning can include it.
        final hasSelectionColumn = identityFieldId != null && onSelectHeaderButton != null;
        // codex: Define the cell text style up front so width calculations match actual rendering.
        final cellTextStyle = TextStyle(fontSize: fontSize);

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
                    // codex: Use layout constraints to derive column widths that prioritize longer content.
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // codex: Compute proportional column widths based on headers, data, and available space.
                        final widthPlan = computeColumnWidthPlan<T>(fields: fields, data: state.data, headerStyle: effectiveHeaderStyle, cellStyle: cellTextStyle, availableWidth: constraints.maxWidth, columnSpacing: columnSpacing, horizontalMargin: horizontalMargin, hasSelectionColumn: hasSelectionColumn, selectionLabel: selectName);
                        // codex: Build header columns constrained to their planned widths.
                        final plannedColumns = <DataColumn>[
                          // codex: Constrain each header so columns compress instead of clipping neighbors.
                          ...fields.asMap().entries.map(
                            (entry) => DataColumn(
                              label: SizedBox(
                                width: widthPlan.columnWidths[entry.key],
                                // codex: Render the sortable/filterable header inside the constrained box so it truncates with the column.
                                child: SortableFilterableW(
                                  fields: fields,
                                  labelId: entry.value.labelId,
                                  onPressed: (updated) => _dispatchFields(context, updated),
                                  onChanged: (updated) => _dispatchFields(context, updated), // codex: Keep header behavior consistent while letting width shrink.
                                  alwaysShowFilter: alwaysShowFilter,
                                  preserveFieldOrderOnSort: preserveFieldOrderOnSort,
                                ),
                              ),
                            ),
                          ),
                          if (hasSelectionColumn)
                            DataColumn(
                              label: SizedBox(
                                width: widthPlan.selectionColumnWidth,
                                child: InkWell(
                                  // codex: Style the selection header using the themed header style so it remains recognizable.
                                  child: Text(selectName, style: effectiveHeaderStyle.copyWith(decoration: TextDecoration.underline)),
                                  onTap: () => onSelectHeaderButton!(state.selectedIds),
                                ),
                              ),
                            ),
                        ];
                        // codex: Create a data source that applies the same column widths so wrapped cells and headers stay aligned.
                        final plannedDataSource = DataGridRowsDTS(state.data, fields, onRowClick, identityFieldId, state.selectedIds, (entries) => _dispatchSelection(context, entries), fontSize: fontSize, onCheckboxChange: onCheckboxChange, onCheckRequirement: onCheckRequirement, columnWidths: widthPlan.columnWidths, selectionColumnWidth: widthPlan.selectionColumnWidth);
                        // codex: Expand the table width when columns exceed the viewport while still allowing full-width layout when they fit.
                        final tableWidth = widthPlan.totalTableWidth > constraints.maxWidth ? widthPlan.totalTableWidth : constraints.maxWidth;
                        // codex: Wrap the table in horizontal scroll to avoid overflow errors on tight layouts.
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: constraints.maxWidth),
                            child: SizedBox(
                              width: tableWidth,
                              // codex: Render the static DataTable with the planned column widths applied.
                              child: DataTable(columnSpacing: columnSpacing, horizontalMargin: horizontalMargin, dividerThickness: 0, showCheckboxColumn: false, dataRowMaxHeight: state.rowHeight, dataRowMinHeight: state.rowHeight, rows: plannedDataSource.getAllRows(), headingRowHeight: state.headerHeight + state.remainderHeight, columns: plannedColumns),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    decoration: const BoxDecoration(),
                    // codex: Apply the same width planning to the paginated table variant.
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // codex: Compute column widths that favor longer content while respecting header minimums.
                        final widthPlan = computeColumnWidthPlan<T>(fields: fields, data: state.data, headerStyle: effectiveHeaderStyle, cellStyle: cellTextStyle, availableWidth: constraints.maxWidth, columnSpacing: columnSpacing, horizontalMargin: horizontalMargin, hasSelectionColumn: hasSelectionColumn, selectionLabel: selectName);
                        // codex: Constrain header widgets to the planned widths for consistent truncation.
                        final plannedColumns = <DataColumn>[
                          // codex: Apply width constraints to each header so columns compress predictably.
                          ...fields.asMap().entries.map(
                            (entry) => DataColumn(
                              label: SizedBox(
                                width: widthPlan.columnWidths[entry.key],
                                // codex: Keep the header widget constrained so pagination uses the same width rules.
                                child: SortableFilterableW(
                                  fields: fields,
                                  labelId: entry.value.labelId,
                                  onPressed: (updated) => _dispatchFields(context, updated),
                                  onChanged: (updated) => _dispatchFields(context, updated), // codex: Preserve header behavior while allowing truncation.
                                  alwaysShowFilter: alwaysShowFilter,
                                  preserveFieldOrderOnSort: preserveFieldOrderOnSort,
                                ),
                              ),
                            ),
                          ),
                          if (hasSelectionColumn)
                            DataColumn(
                              label: SizedBox(
                                width: widthPlan.selectionColumnWidth,
                                child: InkWell(
                                  // codex: Apply the themed style to the selection header for consistency.
                                  child: Text(selectName, style: effectiveHeaderStyle.copyWith(decoration: TextDecoration.underline)),
                                  onTap: () => onSelectHeaderButton!(state.selectedIds),
                                ),
                              ),
                            ),
                        ];
                        // codex: Build a data source that shares the same width constraints so wrapped body cells line up with headers.
                        final plannedDataSource = DataGridRowsDTS(state.data, fields, onRowClick, identityFieldId, state.selectedIds, (entries) => _dispatchSelection(context, entries), fontSize: fontSize, onCheckboxChange: onCheckboxChange, onCheckRequirement: onCheckRequirement, columnWidths: widthPlan.columnWidths, selectionColumnWidth: widthPlan.selectionColumnWidth);
                        // codex: Determine the rendered table width so horizontal scrolling can be enabled when needed.
                        final tableWidth = widthPlan.totalTableWidth > constraints.maxWidth ? widthPlan.totalTableWidth : constraints.maxWidth;
                        // codex: Allow horizontal scrolling to prevent overflow when columns cannot compress further.
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: constraints.maxWidth),
                            child: SizedBox(
                              width: tableWidth,
                              child: SingleChildScrollView(
                                // codex: Render the paginated table using the planned widths so body cells and headers stay aligned.
                                child: AtreeonPaginatedDataTable(columnSpacing: columnSpacing, horizontalMargin: horizontalMargin, showCheckboxColumn: false, showFirstLastButtons: true, dataRowHeight: state.rowHeight, source: plannedDataSource, headingRowHeight: state.headerHeight + (state.remainderHeight / 2), columns: plannedColumns, rowsPerPage: state.rowsPerPage, fontSize: fontSize, iconSize: 20, footerHeight: state.footerHeight + (state.remainderHeight / 2)),
                              ),
                            ),
                          ),
                        );
                      },
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

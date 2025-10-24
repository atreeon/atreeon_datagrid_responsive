import 'dart:math' as math;
import 'dart:ui';

import 'package:atreeon_datagrid_responsive/reusable_data_grid/bloc/reusable_data_grid_event.dart';
import 'package:atreeon_datagrid_responsive/reusable_data_grid/bloc/reusable_data_grid_state.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/logic/multi_filter.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/logic/multi_sort.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template reusable_data_grid_bloc}
/// Bloc that encapsulates all interactive logic for the reusable data grid.
/// {@endtemplate}
class ReusableDataGridBloc<T> extends Bloc<ReusableDataGridEvent<T>, ReusableDataGridState<T>> {
  /// Creates a bloc configured with the initial grid props and data snapshot.
  ReusableDataGridBloc({
    required List<T> data,
    required List<Field<T>> fields,
    required Field<T>? identityField,
    required List<T>? selectedRecords,
    required double? maxHeight,
    required double rowHeight,
    required double headerHeight,
    required double footerHeight,
    required DateTime? lastSaveDate,
  }) : super(
         _buildInitialState(
           data: data,
           fields: fields,
           identityField: identityField,
           selectedRecords: selectedRecords,
           maxHeight: maxHeight,
           rowHeight: rowHeight,
           headerHeight: headerHeight,
           footerHeight: footerHeight,
           lastSaveDate: lastSaveDate,
         ),
       ) {
    on<ReusableDataGridConfigurationChanged<T>>(_onConfigurationChanged);
    on<ReusableDataGridFieldsUpdated<T>>(_onFieldsUpdated);
    on<ReusableDataGridSizeChanged<T>>(_onSizeChanged);
    on<ReusableDataGridSelectionReplaced<T>>(_onSelectionReplaced);
  }

  /// Recomputes the grid snapshot when external props or data change.
  void _onConfigurationChanged(
    ReusableDataGridConfigurationChanged<T> event,
    Emitter<ReusableDataGridState<T>> emit,
  ) {
    final filteredData = _applyTransforms(event.data, event.fields);
    final resolvedSelection = event.clearSelection ? <String>[] : _resolveSelectedIds(event.selectedRecords, event.identityField) ?? state.selectedIds;

    emit(
      state.copyWith_ReusableDataGridState(
        rawData: () => event.data,
        fields: () => event.fields,
        data: () => filteredData,
        identityField: () => event.identityField,
        selectedIds: () => resolvedSelection,
        requestedMaxHeight: () => event.maxHeight,
        rowHeight: () => event.rowHeight,
        headerHeight: () => event.headerHeight,
        footerHeight: () => event.footerHeight,
        lastSaveDate: () => event.lastSaveDate,
        effectiveMaxHeight: () => event.maxHeight,
      ),
    );
  }

  /// Updates the filtered dataset and columns when sort or filter state changes.
  void _onFieldsUpdated(
    ReusableDataGridFieldsUpdated<T> event,
    Emitter<ReusableDataGridState<T>> emit,
  ) {
    final filteredData = _applyTransforms(state.rawData, event.fields);

    emit(
      state.copyWith_ReusableDataGridState(
        fields: () => event.fields,
        data: () => filteredData,
      ),
    );
  }

  /// Updates pagination metrics in response to size measurements.
  void _onSizeChanged(
    ReusableDataGridSizeChanged<T> event,
    Emitter<ReusableDataGridState<T>> emit,
  ) {
    emit(_applyLayout(state, event.size));
  }

  /// Persists the current selection identifiers provided by the table source.
  void _onSelectionReplaced(
    ReusableDataGridSelectionReplaced<T> event,
    Emitter<ReusableDataGridState<T>> emit,
  ) {
    emit(
      state.copyWith_ReusableDataGridState(
        selectedIds: () => event.selectedIds,
      ),
    );
  }

  /// Builds the initial state using the provided props from the widget.
  static ReusableDataGridState<T> _buildInitialState<T>({
    required List<T> data,
    required List<Field<T>> fields,
    required Field<T>? identityField,
    required List<T>? selectedRecords,
    required double? maxHeight,
    required double rowHeight,
    required double headerHeight,
    required double footerHeight,
    required DateTime? lastSaveDate,
  }) {
    final filteredData = _applyTransforms(data, fields);

    return ReusableDataGridState<T>(
      rawData: data,
      fields: fields,
      data: filteredData,
      identityField: identityField,
      selectedIds: _resolveSelectedIds(selectedRecords, identityField) ?? const <String>[],
      rowsPerPage: 100,
      remainderHeight: 0,
      widgetSize: Size.zero,
      effectiveMaxHeight: maxHeight,
      requestedMaxHeight: maxHeight,
      rowHeight: rowHeight,
      headerHeight: headerHeight,
      footerHeight: footerHeight,
      lastSaveDate: lastSaveDate,
    );
  }

  /// Applies filtering and sorting using the provided field definitions.
  static List<T> _applyTransforms<T>(List<T> data, List<Field<T>> fields) {
    return data.multiFilter(fields).multisort(fields).toList();
  }

  /// Calculates pagination metrics for the current state and measured size.
  ReusableDataGridState<T> _applyLayout(
    ReusableDataGridState<T> current,
    Size size,
  ) {
    final requestedMaxHeight = current.requestedMaxHeight;

    if (requestedMaxHeight == null) {
      final computedRowsPerPage = math.max(
        1,
        size.height ~/ current.rowHeight - 2,
      );

      return current.copyWith_ReusableDataGridState(
        rowsPerPage: () => computedRowsPerPage,
        remainderHeight: () => 0,
        widgetSize: () => size,
        effectiveMaxHeight: () => null,
      );
    }

    final rowsHeight = requestedMaxHeight - current.footerHeight - current.headerHeight;
    final computedRowsPerPage = math.max(
      1,
      rowsHeight ~/ current.rowHeight,
    );
    final padding = (current.footerHeight + current.headerHeight + 2) / computedRowsPerPage;
    final remainder = requestedMaxHeight - (computedRowsPerPage * (current.rowHeight + padding));

    var rowsPerPage = computedRowsPerPage;
    var effectiveHeight = requestedMaxHeight;

    if (current.data.length <= rowsPerPage) {
      rowsPerPage = current.data.length;
      effectiveHeight = (rowsPerPage * current.rowHeight) + current.rowHeight;
    }

    return current.copyWith_ReusableDataGridState(
      rowsPerPage: () => rowsPerPage,
      remainderHeight: () => remainder,
      widgetSize: () => size,
      effectiveMaxHeight: () => effectiveHeight,
    );
  }

  /// Converts selected records to identifier strings using the identity field.
  static List<String>? _resolveSelectedIds<T>(
    List<T>? records,
    Field<T>? identityField,
  ) {
    if (records == null || identityField == null) {
      return null;
    }

    return records.map((record) => identityField.fieldDefinition(record)?.toString()).whereType<String>().toList();
  }
}

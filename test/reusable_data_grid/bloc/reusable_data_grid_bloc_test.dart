import 'dart:ui';

import 'package:atreeon_datagrid_responsive/reusable_data_grid/bloc/reusable_data_grid_bloc.dart';
import 'package:atreeon_datagrid_responsive/reusable_data_grid/bloc/reusable_data_grid_event.dart';
import 'package:atreeon_datagrid_responsive/reusable_data_grid/bloc/reusable_data_grid_state.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

/// Minimal row model used to exercise the bloc.
class _Row {
  /// Identifier for the row.
  final int id;

  /// Value displayed in the table.
  final String value;

  /// Creates a test row with [id] and [value].
  const _Row(this.id, this.value);
}

/// Builds a field that reads the [_Row.value] property.
Field<_Row> _buildValueField() => Field<_Row>((row) => row.value, 'value', null);

/// Builds a field that resolves the [_Row.id] property.
Field<_Row> _buildIdentityField() => Field<_Row>((row) => row.id, 'id', null);

void main() {
  group('ReusableDataGridBloc', () {
    test('initial state reflects provided data and selection', () {
      final rows = [const _Row(1, 'a'), const _Row(2, 'b')];
      final bloc = ReusableDataGridBloc<_Row>(
        data: rows,
        fields: [_buildValueField()],
        identityField: _buildIdentityField(),
        selectedRecords: [rows.first],
        maxHeight: null,
        rowHeight: 30,
        headerHeight: 10,
        footerHeight: 10,
        lastSaveDate: DateTime(2024, 1, 1),
      );

      expect(bloc.state.rawData, rows);
      expect(bloc.state.data, rows);
      expect(bloc.state.selectedIds, ['1']);

      bloc.close();
    });

    blocTest<ReusableDataGridBloc<_Row>, ReusableDataGridState<_Row>>(
      'updates filtered data when fields change',
      build: () => ReusableDataGridBloc<_Row>(
        data: const [
          _Row(1, 'a'),
          _Row(2, 'b'),
        ],
        fields: [_buildValueField()],
        identityField: _buildIdentityField(),
        selectedRecords: null,
        maxHeight: null,
        rowHeight: 30,
        headerHeight: 10,
        footerHeight: 10,
        lastSaveDate: null,
      ),
      act: (bloc) => bloc.add(
        ReusableDataGridFieldsUpdated<_Row>(
          fields: [Field<_Row>((row) => row.value.toUpperCase(), 'value', null)],
        ),
      ),
      verify: (bloc) {
        expect(bloc.state.fields.first.labelId, 'value');
        expect(bloc.state.data.map((row) => row.value).toList(), ['a', 'b']);
      },
    );

    blocTest<ReusableDataGridBloc<_Row>, ReusableDataGridState<_Row>>(
      'clears selection when configuration requests reset',
      build: () => ReusableDataGridBloc<_Row>(
        data: const [_Row(1, 'a')],
        fields: [_buildValueField()],
        identityField: _buildIdentityField(),
        selectedRecords: const [_Row(1, 'a')],
        maxHeight: null,
        rowHeight: 30,
        headerHeight: 10,
        footerHeight: 10,
        lastSaveDate: DateTime(2024, 1, 1),
      ),
      act: (bloc) => bloc.add(
        ReusableDataGridConfigurationChanged<_Row>(
          data: const [_Row(1, 'a')],
          fields: [_buildValueField()],
          identityField: _buildIdentityField(),
          selectedRecords: const [_Row(1, 'a')],
          maxHeight: null,
          rowHeight: 30,
          headerHeight: 10,
          footerHeight: 10,
          lastSaveDate: DateTime(2024, 2, 1),
          clearSelection: true,
        ),
      ),
      verify: (bloc) => expect(bloc.state.selectedIds, isEmpty),
    );

    blocTest<ReusableDataGridBloc<_Row>, ReusableDataGridState<_Row>>(
      'recalculates rows per page using provided size',
      build: () => ReusableDataGridBloc<_Row>(
        data: const [_Row(1, 'a'), _Row(2, 'b'), _Row(3, 'c')],
        fields: [_buildValueField()],
        identityField: _buildIdentityField(),
        selectedRecords: null,
        maxHeight: 200,
        rowHeight: 20,
        headerHeight: 20,
        footerHeight: 20,
        lastSaveDate: null,
      ),
      act: (bloc) => bloc.add(
        ReusableDataGridSizeChanged<_Row>(size: const Size(300, 300)),
      ),
      verify: (bloc) {
        expect(bloc.state.rowsPerPage, greaterThan(0));
        expect(bloc.state.effectiveMaxHeight, isNotNull);
      },
    );
  });
}

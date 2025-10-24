import 'package:atreeon_datagrid_responsive/ReusableDataGrid.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/FilterField.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/SortField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Captures a reusable timestamp that ensures the grid rebuilds deterministically.
final DateTime _baselineTimestamp = DateTime(2025, 01, 01, 12, 00);

/// Describes the employees rendered by the paginated golden test.
const List<_Employee> _baselineEmployees = [_Employee(id: 1042, name: 'Ava North', department: 'Operations', hours: 41.5, note: 'Coordinates daily fulfilment windows and monitors courier feedback.'), _Employee(id: 1048, name: 'Bryn Lee', department: 'Logistics', hours: 38.0, note: 'Tracks pallet inventory and prepares status digests for leadership.'), _Employee(id: 1061, name: 'Kai Patel', department: 'Planning', hours: 44.0, note: 'Owns long-range capacity forecasting and scenario modelling.'), _Employee(id: 1073, name: 'Mira Chen', department: 'Planning', hours: 36.5, note: 'Leads vendor audits while mentoring onboarding cohorts.')];

/// Focuses on three rows with verbose notes to exercise wrapping behaviour.
const List<_Employee> _longFormEmployees = [_Employee(id: 201, name: 'Rowan Hale', department: 'Quality', hours: 35.0, note: 'Reviews every incident ticket and documents the follow-up cadence to demonstrate wrapped prose.'), _Employee(id: 202, name: 'Sasha Wilde', department: 'Quality', hours: 37.0, note: 'Runs calibration workshops, capturing bullet points that intentionally exceed a single visual row in the grid.'), _Employee(id: 203, name: 'Theo Malik', department: 'Enablement', hours: 39.5, note: 'Drafts onboarding copy; this sentence continues to force multiple wrapped lines for the golden.')];

/// Supplies the shared identity field that powers selection scenarios.
final Field<_Employee> _identityField = Field<_Employee>((employee) => employee.id, 'id', const FilterFieldNum(), sort: SortField(isAscending: false), format: (employee) => '#${employee.id}');

/// Creates the column definitions that highlight sorting and filtering controls.
List<Field<_Employee>> _buildPaginatedFields() {
  return [Field<_Employee>((employee) => employee.name, 'name', const FilterFieldString(searchText: 'a'), sort: SortField()), Field<_Employee>((employee) => employee.department, 'department', const FilterFieldString()), Field<_Employee>((employee) => employee.hours, 'hours', const FilterFieldNum(), format: (employee) => '${employee.hours.toStringAsFixed(1)} h')];
}

/// Builds fields emphasising long-form notes alongside the identity column.
List<Field<_Employee>> _buildWrappedFields() {
  return [_identityField, Field<_Employee>((employee) => employee.name, 'name', const FilterFieldString()), Field<_Employee>((employee) => employee.note, 'note', const FilterFieldString(searchText: 'workshops'))];
}

/// Configures the grid for selection tests complete with footer actions.
List<Field<_Employee>> _buildSelectionFields() {
  return [Field<_Employee>((employee) => employee.department, 'department', const FilterFieldString()), Field<_Employee>((employee) => employee.note, 'note', const FilterFieldString())];
}

/// Wraps the [ReusableDataGrid] in a themed [MaterialApp] for golden capture.
Widget _buildHostApp({required List<_Employee> rows, required List<Field<_Employee>> fields, Field<_Employee>? identityField, List<_Employee>? selected, void Function(List<String>)? onHeaderSelect, VoidCallback? onCreate, double? maxHeight, double rowHeight = 52, double headerHeight = 48, double footerHeight = 48, double fontSize = 14}) {
  return MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 720),
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: SizedBox(
            height: maxHeight ?? 480,
            child: Column(
              children: [
                // Data grid under test.
                ReusableDataGrid<_Employee>(data: rows, fields: fields, identityFieldId: identityField, selectedIds: selected, onSelectHeaderButton: onHeaderSelect, selectName: 'Delete', onCreateClick: onCreate, maxHeight: maxHeight, rowHeight: rowHeight, headerHeight: headerHeight, footerHeight: footerHeight, lastSaveDate: _baselineTimestamp, fontSize: fontSize, columnSpacing: 24, horizontalMargin: 18),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  /// Groups reusable data grid golden baselines that mirror the public demos.
  group('ReusableDataGrid goldens', () {
    /// Verifies that the paginated layout with filters stays visually stable.
    testWidgets('paginated overview', (tester) async {
      await tester.binding.setSurfaceSize(const Size(900, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildHostApp(rows: _baselineEmployees, fields: _buildPaginatedFields(), headerHeight: 56, footerHeight: 64, rowHeight: 60, fontSize: 16));

      await tester.pumpAndSettle();

      await expectLater(find.byType(ReusableDataGrid<_Employee>), matchesGoldenFile('goldens/paginated_overview.png'));
    });

    /// Locks in the fixed-height table used when content wraps within constrained rows.
    testWidgets('static table with wrapping cells', (tester) async {
      await tester.binding.setSurfaceSize(const Size(900, 560));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildHostApp(rows: _longFormEmployees, fields: _buildWrappedFields(), maxHeight: 260, rowHeight: 72, headerHeight: 48, footerHeight: 40));

      await tester.pumpAndSettle();

      await expectLater(find.byType(ReusableDataGrid<_Employee>), matchesGoldenFile('goldens/static_wrapped_rows.png'));
    });

    /// Captures the selectable configuration that surfaces header actions and create button.
    testWidgets('selection with create action', (tester) async {
      await tester.binding.setSurfaceSize(const Size(900, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildHostApp(rows: _baselineEmployees, fields: _buildSelectionFields(), identityField: _identityField, selected: [_baselineEmployees[1], _baselineEmployees[2]], onHeaderSelect: (_) {}, onCreate: () {}, maxHeight: 320, rowHeight: 64, headerHeight: 52, footerHeight: 56));

      await tester.pumpAndSettle();

      await expectLater(find.byType(ReusableDataGrid<_Employee>), matchesGoldenFile('goldens/selection_with_create.png'));
    });
  });
}

/// Immutable value that backs each grid row across the golden scenarios.
class _Employee {
  const _Employee({required this.id, required this.name, required this.department, required this.hours, required this.note});

  final int id;

  final String name;

  final String department;

  final double hours;

  final String note;
}

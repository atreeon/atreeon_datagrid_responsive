/// Integration style tests covering multi-filter, multi-sort and selection behaviors.
///
/// The scenarios exercise how filter and sort rules interact before data reaches the
/// [DataGridRowsDTS] selection pipeline, ensuring future refactors keep the guarantees
/// offered by the existing helpers.
import 'package:atreeon_datagrid_responsive/dataGridWidgets/DataGridRowsDTS.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/logic/multi_filter.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/logic/multi_sort.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/FilterField.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/SortField.dart';
import 'package:test/test.dart';

/// Test double that mimics a row inside the inventory grid used throughout this suite.
class _InventoryItem {
  /// Identifier surfaced by the `identityField`.
  final String id;

  /// Category label used by string filters.
  final String category;

  /// Numerical value that participates in numeric filters and sort orders.
  final num price;

  /// A human readable representation of [price] used by UI cells.
  final String formattedPrice;

  /// Builds an inventory row with both the raw and formatted price representations.
  const _InventoryItem({
    required this.id,
    required this.category,
    required this.price,
    required this.formattedPrice,
  });
}

/// Lightweight row used for validating the selection mechanics of [DataGridRowsDTS].
class _SelectableRow {
  /// Identifier surfaced through the `identityField` for checkbox interactions.
  final String id;

  /// Title displayed in the only visible column for the selection tests.
  final String label;

  /// Builds the row with the raw identifier and human readable label.
  const _SelectableRow({
    required this.id,
    required this.label,
  });
}

void main() {
  /// Exercises the combination of string and numeric filters before sorting the results.
  group('multiFilter and multiSort integration', () {
    test('filters on string and numeric values before sorting filtered subset', () {
      /// Inventory rows with a mix of categories and price ranges.
      final items = <_InventoryItem>[
        const _InventoryItem(id: 'laptop-pro', category: 'Laptops', price: 2600, formattedPrice: 'USD 2600'),
        const _InventoryItem(id: 'desktop-creative', category: 'Desktops', price: 3200, formattedPrice: 'USD 3200'),
        const _InventoryItem(id: 'laptop-air', category: 'Laptops', price: 1400, formattedPrice: 'USD 1400'),
        const _InventoryItem(id: 'tablet-lite', category: 'Tablets', price: 700, formattedPrice: 'USD 700'),
      ];

      /// Filtering configuration combining category matching and a minimum price requirement.
      final filterFields = <Field<_InventoryItem>>[
        Field<_InventoryItem>(
          (item) => item.category,
          'category',
          FilterFieldString(
            searchText: 'lap',
            stringFilterType: eStringFilterType.contains,
          ),
        ),
        Field<_InventoryItem>(
          (item) => item.price,
          'price',
          FilterFieldNum(
            filter1: 1500,
            numFilterType: eNumFilterType.gt,
          ),
        ),
      ];

      /// Sort setup ordering laptops by category first, then price descending.
      final sortFields = <Field<_InventoryItem>>[
        Field<_InventoryItem>(
          (item) => item.category,
          'category',
          null,
          sort: SortField(isAscending: true),
        ),
        Field<_InventoryItem>(
          (item) => item.price,
          'price',
          null,
          sort: SortField(isAscending: false),
        ),
      ];

      final filtered = items.multiFilter(filterFields);
      final sorted = filtered.multisort(sortFields).toList();

      expect(sorted.map((e) => e.id).toList(), <String>['laptop-pro']);
    });

    test('filters using alternate definition before sorting on formatted value', () {
      /// Inventory rows where the UI shows formatted prices but filters rely on the raw numeric data.
      final items = <_InventoryItem>[
        const _InventoryItem(id: 'desktop-entry', category: 'Desktops', price: 900, formattedPrice: 'USD 900'),
        const _InventoryItem(id: 'desktop-pro', category: 'Desktops', price: 1900, formattedPrice: 'USD 1,900'),
        const _InventoryItem(id: 'desktop-extreme', category: 'Desktops', price: 2600, formattedPrice: 'USD 2,600'),
      ];

      /// Filtering configuration applying a numeric range over the hidden raw values.
      final filterFields = <Field<_InventoryItem>>[
        Field<_InventoryItem>(
          (item) => item.formattedPrice,
          'price',
          FilterFieldNum(
            filter1: 1500,
            filter2: 2500,
            numFilterType: eNumFilterType.between,
          ),
          fieldDefForSortFilter: (item) => item.price,
        ),
      ];

      /// Sort setup ordering by the formatted price text so the test inspects formatted values.
      final sortFields = <Field<_InventoryItem>>[
        Field<_InventoryItem>(
          (item) => item.formattedPrice,
          'price',
          null,
          sort: SortField(isAscending: true),
        ),
      ];

      final filtered = items.multiFilter(filterFields);
      final sorted = filtered.multisort(sortFields).toList();

      expect(sorted.map((e) => e.formattedPrice).toList(), <String>['USD 1,900']);
    });
  });

  /// Validates the behavior of [DataGridRowsDTS] around selection toggles and guard rails.
  group('DataGridRowsDTS selection', () {
    test('adds missing selection when a row is tapped', () {
      /// Collects all selection change notifications fired by the data source.
      final selectionNotifications = <List<String>>[];

      /// Rows provided to the data source, including the one being selected.
      final rows = <_SelectableRow>[
        const _SelectableRow(id: 'alpha', label: 'Alpha'),
        const _SelectableRow(id: 'beta', label: 'Beta'),
      ];

      /// Field definitions representing the only visible label column.
      final fields = <Field<_SelectableRow>>[
        Field<_SelectableRow>((row) => row.label, 'label', null),
      ];

      /// The data source under test exposing a checkbox column through [identityField].
      final source = DataGridRowsDTS<_SelectableRow>(
        rows,
        fields,
        (row, ids) => selectionNotifications.add(List<String>.from(ids)..add(row.id)),
        Field<_SelectableRow>((row) => row.id, 'id', null),
        const <String>[],
        (ids) => selectionNotifications.add(List<String>.from(ids)),
        fontSize: 12,
        onCheckboxChange: (ids) => ids.map((id) => id.toUpperCase()).toList(),
        onCheckRequirement: (_) => true,
      );

      final row = source.getRow(0);

      row.onSelectChanged?.call(true);

      expect(selectionNotifications.last, <String>['ALPHA']);
    });

    test('removes selection when toggled off', () {
      /// Collects the resulting selections emitted when rows get deselected.
      final selectionNotifications = <List<String>>[];

      /// The existing selection before user interaction occurs.
      const initialSelection = <String>['beta'];

      /// Field definitions representing the label column for the test rows.
      final fields = <Field<_SelectableRow>>[
        Field<_SelectableRow>((row) => row.label, 'label', null),
      ];

      /// Source preconfigured with an initial selection so toggling removes the identifier.
      final source = DataGridRowsDTS<_SelectableRow>(
        const <_SelectableRow>[
          _SelectableRow(id: 'alpha', label: 'Alpha'),
          _SelectableRow(id: 'beta', label: 'Beta'),
        ],
        fields,
        null,
        Field<_SelectableRow>((row) => row.id, 'id', null),
        initialSelection,
        (ids) => selectionNotifications.add(List<String>.from(ids)),
        fontSize: 12,
        onCheckboxChange: (ids) => ids,
      );

      final row = source.getRow(1);

      row.onSelectChanged?.call(true);

      expect(selectionNotifications.single, isEmpty);
    });

    test('blocks selection when requirement fails', () {
      /// Tracks whether [onSelected] gets invoked so the guard can be asserted.
      var didNotifySelection = false;

      /// Field definitions representing the label column so rows can render.
      final fields = <Field<_SelectableRow>>[
        Field<_SelectableRow>((row) => row.label, 'label', null),
      ];

      /// Source configured with a guard that prevents additional selections until the requirement passes.
      final source = DataGridRowsDTS<_SelectableRow>(
        const <_SelectableRow>[
          _SelectableRow(id: 'alpha', label: 'Alpha'),
        ],
        fields,
        null,
        Field<_SelectableRow>((row) => row.id, 'id', null),
        const <String>[],
        (_) => didNotifySelection = true,
        fontSize: 12,
        onCheckRequirement: (_) => false,
      );

      final row = source.getRow(0);

      row.onSelectChanged?.call(true);

      expect(didNotifySelection, isFalse);
    });
  });
}

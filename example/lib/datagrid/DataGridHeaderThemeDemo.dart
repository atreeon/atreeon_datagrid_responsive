import 'package:atreeon_datagrid_responsive/ReusableDataGrid.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/FilterField.dart';
import 'package:atreeon_datagrid_responsive/theme/data_grid_header_theme.dart';
import 'package:flutter/material.dart';

/// Sample data model used by the grid.
class Item {
  /// Display name.
  final String name;

  /// RAM in GB.
  final int ram;

  /// Price in arbitrary units.
  final int price;

  /// Storage capacity.
  final int storage;

  /// Creates an [Item].
  Item(this.name, this.ram, this.price, this.storage);
}

/// {@template s_datagrid_header_theme_demo}
/// Demonstrates switching between regular and large DataGrid header styles
/// using the `DataGridHeaderTheme` extension. The demo keeps the grid code
/// unchanged; sizing comes entirely from the theme.
///
/// Use the toggle to switch between presets at runtime.
/// {@endtemplate}
class SDataGridHeaderThemeDemo extends StatefulWidget {
  /// {@macro s_datagrid_header_theme_demo}
  const SDataGridHeaderThemeDemo({super.key});

  @override
  State<SDataGridHeaderThemeDemo> createState() => _SDataGridHeaderThemeDemoState();
}

class _SDataGridHeaderThemeDemoState extends State<SDataGridHeaderThemeDemo> {
  /// Whether the large header preset is active.
  bool _useLarge = true;

  /// Generates a small dataset for quick visual checks.
  final List<Item> _data = List<Item>.generate(
    50,
    (i) => Item('Item $i', (i % 8 + 1) * 2, 100 + i, 32 + i),
  );

  @override
  Widget build(BuildContext context) {
    // Choose the header theme preset based on the toggle.
    final base = Theme.of(context);
    final headerPreset = _useLarge
        ? DataGridHeaderTheme.large(base.textTheme)
        : DataGridHeaderTheme.regular(base.textTheme);

    return Theme(
      // Provide the header theme locally so this page can switch presets
      // without affecting the rest of the app.
      data: base.copyWith(extensions: <ThemeExtension<dynamic>>[headerPreset]),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Header Theme Demo'),
          actions: [
            Row(
              children: [
                const Text('Regular'),
                Switch(
                  value: _useLarge,
                  onChanged: (v) => setState(() => _useLarge = v),
                ),
                const Text('Large'),
                const SizedBox(width: 12),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ReusableDataGrid<Item>(
                data: _data,
                fields: [
                  Field<Item>((x) => x.name, 'Name', FilterFieldString()),
                  Field<Item>((x) => x.ram, 'RAM', FilterFieldNum()),
                  Field<Item>((x) => x.price, 'Price', FilterFieldNum()),
                  Field<Item>((x) => x.storage, 'Storage', FilterFieldNum()),
                ],
                // Leave headerHeight null so the theme controls it.
                footerHeight: 28,
                rowHeight: 32,
                lastSaveDate: null,
                // Show the filter icon always so the themed icon size is visible.
                alwaysShowFilter: true,
                // Keep the grid’s base text small to highlight the header change.
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

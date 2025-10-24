import 'dart:io';

import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/FilterField.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/SortField.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/widgets/FilterBox.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/widgets/SortableButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

/// Shared label identifier used across test fixtures.
const String _testLabelId = 'Name';

/// Wraps a widget in the minimum Material scaffolding required for interaction testing.
Widget wrapWithMaterial(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

/// Builds a [Field] collection seeded with a single filterable entry.
List<Field<String>> buildFields({required bool filtered}) => [
  Field<String>(
    (value) => value,
    _testLabelId,
    filtered ? const FilterFieldString(searchText: 'a') : const FilterFieldString(),
    sort: filtered ? SortField(isAscending: true) : null,
  ),
];

/// Convenience factory for a configured [SortableButton] under test.
Widget buildButton({
  required bool alwaysShowFilter,
  required List<Field<String>> fields,
  void Function(List<Field<String>>)? onPressed,
}) {
  return SortableButton<String>(
    fields,
    _testLabelId,
    onPressed ?? (_) {},
    fontSize: 16,
    alwaysShowFilter: alwaysShowFilter,
  );
}

/// Exercises [SortableButton] filter affordances and captures golden snapshots for both modes.
void main() {
  GoldenToolkit.runWithConfiguration(
    () {
      setUpAll(() async {
        await loadAppFonts();
        await _loadMaterialIconFont();
      });

      testWidgets(
        'long press opens filter dialog when alwaysShowFilter is false',
        (tester) async {
          var dialogOpened = false;

          await tester.pumpWidget(
            wrapWithMaterial(
              buildButton(
                alwaysShowFilter: false,
                fields: buildFields(filtered: true),
                onPressed: (_) => dialogOpened = true,
              ),
            ),
          );

          await tester.longPress(find.text(_testLabelId));
          await tester.pumpAndSettle();

          expect(find.byType(AlertDialog), findsOneWidget);
          expect(dialogOpened, isFalse);

          await tester.tap(find.text('Clear All Filters'));
          await tester.pumpAndSettle();
        },
      );

      testWidgets(
        'alwaysShowFilter renders toggle icon and opens dialog on tap',
        (tester) async {
          await tester.pumpWidget(
            wrapWithMaterial(
              buildButton(
                alwaysShowFilter: true,
                fields: buildFields(filtered: false),
              ),
            ),
          );

          expect(find.byIcon(Icons.filter_alt_off_outlined), findsOneWidget);

          await tester.tap(find.byTooltip("Filter by '$_testLabelId'"));
          await tester.pumpAndSettle();

          expect(find.byType(AlertDialog), findsOneWidget);
          expect(find.byType(FilterBox<String>), findsOneWidget);

          await tester.tap(find.text('Clear All Filters'));
          await tester.pumpAndSettle();
        },
      );

      testWidgets(
        'alwaysShowFilter toggles to filtered icon when criteria exist',
        (tester) async {
          await tester.pumpWidget(
            wrapWithMaterial(
              buildButton(
                alwaysShowFilter: true,
                fields: buildFields(filtered: true),
              ),
            ),
          );

          expect(find.byIcon(Icons.filter_alt), findsOneWidget);
        },
      );

      testGoldens(
        'alwaysShowFilter visual states',
        (tester) async {
          final builder = DeviceBuilder()
            ..overrideDevicesForAllScenarios(devices: const [Device.phone])
            ..addScenario(
              name: 'unfiltered',
              widget: wrapWithMaterial(
                buildButton(
                  alwaysShowFilter: true,
                  fields: buildFields(filtered: false),
                ),
              ),
            )
            ..addScenario(
              name: 'filtered',
              widget: wrapWithMaterial(
                buildButton(
                  alwaysShowFilter: true,
                  fields: buildFields(filtered: true),
                ),
              ),
            );

          await tester.pumpDeviceBuilder(builder);
          await screenMatchesGolden(
            tester,
            'sortable_button_always_show_states',
          );
        },
      );
    },
    config: GoldenToolkitConfiguration(),
  );
}

/// Loads the Material icon font from the current Flutter SDK for golden fidelity.
Future<void> _loadMaterialIconFont() async {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot == null || flutterRoot.isEmpty) {
    return;
  }

  final iconPath = [
    flutterRoot,
    'bin',
    'cache',
    'artifacts',
    'material_fonts',
    'MaterialIcons-Regular.otf',
  ].join(Platform.pathSeparator);

  final iconFile = File(iconPath);
  if (!await iconFile.exists()) {
    return;
  }

  final bytes = await iconFile.readAsBytes();
  final byteData = ByteData.view(Uint8List.fromList(bytes).buffer);

  final loader = FontLoader('MaterialIcons')..addFont(Future.value(byteData));
  await loader.load();
}

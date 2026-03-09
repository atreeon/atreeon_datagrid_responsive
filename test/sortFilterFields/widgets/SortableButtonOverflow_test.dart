import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/FilterField.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/SortField.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/widgets/SortableButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Shared long header label used to force truncation in narrow layouts.
const String _longLabelId = 'Very long sortable header label';

/// Wraps the test widget in the minimum Material structure and a tight width.
Widget _buildHost({
  required Widget child,
  required double width,
}) {
  // The fixed-width box reproduces the narrow header constraints used by the data grid.
  final constrainedChild = SizedBox(width: width, child: child);

  // The Material host gives Ink widgets the environment they need during testing.
  return MaterialApp(
    home: Scaffold(body: Center(child: constrainedChild)),
  );
}

/// Builds a single sortable and filterable field with a deliberately long label.
List<Field<String>> _buildFields({
  required bool filtered,
  required bool sorted,
}) {
  // The long header text is the part under test, while the filter and sort state add icon pressure.
  return [Field<String>((value) => value, _longLabelId, filtered ? const FilterFieldString(searchText: 'needle') : const FilterFieldString(), sort: sorted ? SortField(isAscending: true) : null)];
}

/// Creates the [SortableButton] configuration shared by the overflow tests.
Widget _buildButton({
  required bool alwaysShowFilter,
  required bool filtered,
  required bool sorted,
}) {
  // The test keeps the font size explicit so truncation behaviour is stable across environments.
  return SortableButton<String>(
    _buildFields(filtered: filtered, sorted: sorted),
    _longLabelId,
    (_) {},
    fontSize: 16,
    alwaysShowFilter: alwaysShowFilter,
  );
}

/// Reads the rendered header text so the tests can assert truncation settings.
Text _readHeaderText(WidgetTester tester) {
  // The long label appears once in the widget tree and identifies the header text widget under test.
  return tester.widget<Text>(find.text(_longLabelId));
}

/// Verifies that narrow header widths truncate instead of producing flex overflows.
void main() {
  testWidgets('truncates without overflow when alwaysShowFilter is false', (tester) async {
    // The narrow width reproduces the column width that previously overflowed in picker tables.
    await tester.pumpWidget(_buildHost(width: 88, child: _buildButton(alwaysShowFilter: false, filtered: true, sorted: true)));

    // A settled frame ensures layout and painting complete before exceptions are inspected.
    await tester.pumpAndSettle();

    // Any RenderFlex overflow would be surfaced here as a test exception.
    expect(tester.takeException(), isNull);

    // The header text should now truncate to one line instead of insisting on its full intrinsic width.
    final headerText = _readHeaderText(tester);

    // Ellipsis is the visible contract that keeps the header stable in narrow columns.
    expect(headerText.maxLines, 1);
    expect(headerText.overflow, TextOverflow.ellipsis);
    expect(headerText.softWrap, isFalse);
  });

  testWidgets('truncates without overflow when alwaysShowFilter is true', (tester) async {
    // The slightly wider width still forces compression while leaving room for the filter button.
    await tester.pumpWidget(_buildHost(width: 112, child: _buildButton(alwaysShowFilter: true, filtered: true, sorted: true)));

    // A settled frame ensures the button row has fully laid out before assertions run.
    await tester.pumpAndSettle();

    // Any remaining overflow in the outer row would surface as a caught exception.
    expect(tester.takeException(), isNull);

    // The filter affordance should remain present while the label yields space first.
    expect(find.byIcon(Icons.filter_alt), findsOneWidget);

    // The header text should keep the same truncation contract in always-show mode.
    final headerText = _readHeaderText(tester);

    // The button still uses a single-line ellipsis even when the filter icon is permanently visible.
    expect(headerText.maxLines, 1);
    expect(headerText.overflow, TextOverflow.ellipsis);
    expect(headerText.softWrap, isFalse);
  });
}

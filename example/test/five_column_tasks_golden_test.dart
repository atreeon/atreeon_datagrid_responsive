import 'package:example/datagrid/DataGridFiveColumnTasksDemo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// {@template five_column_tasks_golden_host}
/// Provides the MaterialApp wrapper to render [DataGridFiveColumnTasksDemo] for goldens.
/// {@endtemplate}
Widget _buildDemoHost() => MaterialApp(
  theme: ThemeData(useMaterial3: true, visualDensity: VisualDensity.compact, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
  home: const DataGridFiveColumnTasksDemo(),
);

/// Logical dimensions matching the iPhone SE (1st generation) viewport.
const Size _iphoneSeFirstGenSize = Size(320, 568);

/// Logical dimensions matching the iPhone 8 viewport.
const Size _iphoneEightSize = Size(375, 667);

/// Logical dimensions matching the iPhone 14 viewport.
const Size _iphoneFourteenSize = Size(390, 844);

/// Pumps the demo widget at a specific device [size] to prepare a golden frame.
///
/// The helper sets the surface size, renders the widget tree, and waits for all
/// scheduled frames to settle before capture.
Future<void> _pumpDemoAtSize(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(_buildDemoHost());
  await tester.pumpAndSettle();
}

/// Exercises the five-column tasks demo across three small iPhone layouts to
/// lock in the responsive behaviour of the grid.
void main() {
  group('DataGridFiveColumnTasksDemo goldens', () {
    testWidgets('renders on iPhone SE first generation layout', (tester) async {
      await _pumpDemoAtSize(tester, _iphoneSeFirstGenSize);

      await expectLater(find.byType(DataGridFiveColumnTasksDemo), matchesGoldenFile('goldens/five_column_tasks_iphone_se_first_gen.png'));
    });

    testWidgets('renders on iPhone 8 layout at 375x667', (tester) async {
      await _pumpDemoAtSize(tester, _iphoneEightSize);

      await expectLater(find.byType(DataGridFiveColumnTasksDemo), matchesGoldenFile('goldens/five_column_tasks_iphone_8.png'));
    });

    testWidgets('renders on iPhone 14 layout for taller screens', (tester) async {
      await _pumpDemoAtSize(tester, _iphoneFourteenSize);

      await expectLater(find.byType(DataGridFiveColumnTasksDemo), matchesGoldenFile('goldens/five_column_tasks_iphone_14.png'));
    });
  });
}

import 'package:atreeon_menu_flutter/menuItem.dart';
import 'package:atreeon_menu_flutter/menuSand.dart';
import 'package:example/datagrid/DataGridCheckRequirementDemo.dart';
import 'package:example/datagrid/DataGridDateDemo.dart';
import 'package:example/datagrid/DataGridFilterSelectableItemsDemo.dart';
import 'package:example/datagrid/DataGridHeightsDemo.dart';
import 'package:example/datagrid/DataGridHidePaginationDemo.dart';
import 'package:example/datagrid/DataGridHighlightedRowsDemo.dart';
import 'package:example/datagrid/DataGridInAColumnEtcDemo.dart';
import 'package:example/datagrid/DataGridMaxHeightDemo.dart';
import 'package:example/datagrid/DataGridMaxItemsDemo.dart';
import 'package:example/datagrid/DataGridPublicDemo.dart';
import 'package:example/datagrid/DataGridRebuildDemo.dart';
import 'package:example/datagrid/DataGridSortHasBeenSetDemo.dart';
import 'package:example/datagrid/DataGridWrapLongTextDemo.dart';
import 'package:example/datagrid/DatagridPreSelectedItemsDemo.dart';
import 'package:example/supporting/DataTableDefaultExample.dart';
import 'package:example/supporting/PaginatedDataTableDefaultExample.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'datagrid/DataGridFilterSortSetDemo.dart';
import 'datagrid/VeryLongListDemo.dart';
import 'supporting/TextEditingControllerExample.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      );
}

class MyHomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return SafeArea(
      child: MenuSand("Datagrid", [
        MenuSubMenu("Datagrid Demos", [
          MenuItemAdi("DataGridMaxItemsDemo", () => DataGridMaxItemsDemo()),
          MenuItemAdi("DataGridSortHasBeenSetDemo", () => DataGridSortHasBeenSetDemo()),
          MenuItemAdi("DataGridCheckRequirementDemo", () => DataGridCheckRequirementDemo()),
          MenuItemAdi("DataGridRebuildDemo", () => DataGridRebuildDemo()),
          MenuItemAdi("DataGridHighlightedRowsDemo", () => DataGridHighlightedRowsDemo()),
          MenuItemAdi("DataGridPublicDemo", () => DataGridPublicDemo()),
          MenuItemAdi("DataGridHeightsDemo", () => DataGridHeightsDemo()),
          MenuItemAdi("DataGridWrapLongTextDemo", () => DataGridWrapLongTextDemo()),
          MenuItemAdi("DataGridDateDemo", () => DataGridDateDemo()),
          MenuItemAdi("DataGridFilterSortSetDemo", () => DataGridFilterSortSetDemo()),
          MenuItemAdi("VeryLongListDemo", () => VeryLongListDemo()),
          MenuItemAdi("DataGridHidePaginationDemo", () => DataGridHidePaginationDemo()),
          MenuItemAdi("DataGridFilterSelectableItemsDemo", () => DataGridFilterSelectableItemsDemo()),
          MenuItemAdi("DatagridPreSelectedItemsDemo", () => DatagridPreSelectedItemsDemo()),
          MenuItemAdi("DataGridMaxHeightDemo", () => DataGridMaxHeightDemo()),
          MenuItemAdi("DataGridInAColumnEtcDemo", () => DataGridInAColumnEtcDemo()),
        ]),
        MenuSubMenu("supporting", [
          MenuItemAdi("TextEditingControllerExample", () => TextEditingControllerExample()),
          MenuItemAdi("PaginatedDataTableDefaultExample", () => PaginatedDataTableDefaultExample()),
          MenuItemAdi("DataTableDefaultExample", () => DataTableDefaultExample()),
        ]),
      ]),
    );
  }
}

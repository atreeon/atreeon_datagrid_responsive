import 'package:atreeon_datagrid_responsive/ReusableDataGrid.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/FilterField.dart';
import 'package:flutter/material.dart';

/// Class of Items
class Item {
  int id;
  String name;

  Item(this.id, this.name);
}

enum Item$ { name, ram }

var originalData = <Item>[Item(1, "Adrian"), Item(2, "B"), Item(3, "CX"), Item(4, "C"), Item(5, "D"), Item(6, "E"), Item(7, "F"), Item(11, "Adrian"), Item(12, "B"), Item(13, "CX"), Item(14, "C"), Item(15, "D"), Item(16, "E"), Item(17, "F"), Item(21, "Adrian"), Item(22, "B"), Item(23, "CX"), Item(24, "C"), Item(25, "D"), Item(26, "E"), Item(27, "F"), Item(31, "Adrian"), Item(32, "B"), Item(33, "CX"), Item(34, "C"), Item(35, "D"), Item(36, "E"), Item(37, "F")];

var ramLookup = {64: "sixtyfour", 1: "one", 128: "1two8"};

class DatagridPreSelectedItemsDemo extends StatelessWidget {

  const DatagridPreSelectedItemsDemo({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(

            child: ReusableDataGrid<Item>(
              data: originalData,

              fields: [
                Field((x) => x.id, "id", FilterFieldNum()),
                Field((x) => x.name, "name", FilterFieldString()),
              ],

              onRowClick: (x, y) => print(x.toString()),
              lastSaveDate: null,

              identityFieldId: Field((x) => x.id, "id", FilterFieldNum()),
              onSelectHeaderButton:
                  (x) => //
                      print(x.toString()),
              selectedIds: [Item(11, "Adrian"), Item(12, "B"), Item(35, "D")],
              fontSize: 12,
              headerHeight: 20,
              footerHeight: 20,
            ),
          ),
        ],
      ),
    );
  }
}

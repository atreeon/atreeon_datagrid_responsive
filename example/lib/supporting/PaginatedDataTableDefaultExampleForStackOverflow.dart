import 'package:flutter/material.dart';

class PaginatedDataTableDefaultExample extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PaginatedDataTable(
            source: DTS(data),
            rowsPerPage: 5,
            columns: [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Text')),
            ],
          ),
          DataTable(
            columns: [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Text')),
            ],
            rows: data.entries
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(e.key.toString())),
                      DataCell(Text(e.value)),
                    ],
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}

class DTS extends DataTableSource {
  final Map<int, String> data;

  DTS(this.data);

  DataRow getRow(int i) {
    return DataRow.byIndex(
      index: i,
      cells: [
        DataCell(Text(i.toString())),
        DataCell(Text(this.data[i]!)),
      ],
    );
  }

  int get rowCount => data.length;

  bool get isRowCountApproximate => false;

  int get selectedRowCount => 0;
}

final data = {
  0: "Black-bellied Whistling-Duck: carrot beak, cinnamon chest, wings have a white stripe and are edged in black",
  1: "Snow Goose: white goose with a shorter neck than trumpeter swan, grin patch on beak; blue morph has a black-gray body with white head and belly ",
  2: "Canada Goose: brown body, white belly, black head and neck, white chinstrap",
  3: "Trumpeter Swan: white swan with longer neck than snow goose, juveniles have orange on the beak and look ashy, breeding individuals have rusty head ",
  4: "Wood Duck: male has splendid plumage and a slicked-back crest, female has a white ring and teardrop around the eye, male in eclipse plumage is dull, lacks the crest, and has a white stripe on the cheek",
  5: "Mallard: your typical duck, male has green head, yellow bill, and brown chest, females are streakier than green-winged teals, both sexes have powder-blue speculums on the wing (note: any bird's speculum may not be visible unless in flight)",
  6: "Northern Shoveler: distinctive wide flat bill used to feed from the top of the water, males have green head like mallard but white chest (not brown), females have wide orange bills unlike green-winged and mallard (who have normally-shaped black ones), both sexes have powder-blue speculums",
  7: "Green-winged Teal: males have green crescent running from the eye toward the back of the head, females have softer, more rounded patterns than streaky mallards, both sexes have bright green speculums",
  8: "Canvasback: distinctively long sloping forehead on both sexes, males have cinnamon head, black chest, white body, females have brown instead of cinnamon and black ",
};

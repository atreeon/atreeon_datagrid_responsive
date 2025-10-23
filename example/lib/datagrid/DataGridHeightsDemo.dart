import 'package:atreeon_datagrid_responsive/ReusableDataGrid.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/FilterField.dart';
import 'package:flutter/material.dart';

final data = {
  1: "There is no fear for one whose mind is not filled with desires. Buddha",
  2: "All that we are is the result of what we have thought. Buddha",
  3: "Do not look for a sanctuary in anyone except your self. Buddha",
  4: "No one saves us but ourselves. No one can and no one may. We ourselves must walk the path. Buddha",
  5: "Dogen To study the Buddha Way is to study the self. To study the self is to forget the self. To forget the self is to be actualized by myriad things. When actualized by myriad things, your body and mind as well as the bodies and minds of others drop away. No trace of enlightenment remains, and this no-trace continues endlessly",
  6: "Resolutly avoid creating own tooling and packages - no exepections",
  7: "William James - Seize the very first possible opportunity to act on every resolution you make",
  8: "Alexander Bain - it is necessary, above all things, never to lose a battle. Every gain on the wrong side undoes the effect of many conquests on the right",
  9: "Louis L'Amour - Victory is won not in miles but in inches, win a little now, hold your ground and later, win a little more",
  10: "Emmet's law - The dread of doing a task uses up more time and energy thean doing the task itself",
  11: "Robert Greene - You shall find that delay breeds danger, and that procrastination in perils is but the mother of mishap",
  12: "Meditate daily",
  14: "Get to work early",
  15: "Check email after 4pm only",
  16: "Discipline is freedom",
  17: "Start work early",
  18: "Set timers for breaks",
  19: "Keep simple. More logic is more work & maintenance",
}.entries.map((e) => MapEntry(e.key, e.value)).toList();

class DataGridHeightsDemo extends StatefulWidget {
  const DataGridHeightsDemo({super.key});

  @override
  _DataGridHeightsDemoState createState() => _DataGridHeightsDemoState();
}

class _DataGridHeightsDemoState extends State<DataGridHeightsDemo> {
  var dateUpdated = DateTime.now();

  final maxHeightController = TextEditingController(text: '250');
  final rowHeightController = TextEditingController(text: '30');
  final headerHeightController = TextEditingController(text: '25');
  final footerHeightController = TextEditingController(text: '25');
  final fontSizeController = TextEditingController(text: '12');
  final columnSpacingController = TextEditingController(text: '12');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('This demo is to show how page handles different heights.'),
          Table(
            children: [
              TableRow(
                children: [
                  Text('Max Height (empty for null)'),
                  TextField(controller: maxHeightController, decoration: InputDecoration(isDense: true)),
                ],
              ),
              TableRow(
                children: [
                  Text('Row Height'),
                  TextField(controller: rowHeightController, decoration: InputDecoration(isDense: true)),
                ],
              ),
              TableRow(
                children: [
                  Text('Header Height'),
                  TextField(controller: headerHeightController, decoration: InputDecoration(isDense: true)),
                ],
              ),
              TableRow(
                children: [
                  Text('Footer Height'),
                  TextField(controller: footerHeightController, decoration: InputDecoration(isDense: true)),
                ],
              ),
              TableRow(
                children: [
                  Text('Font Size'),
                  TextField(controller: fontSizeController, decoration: InputDecoration(isDense: true)),
                ],
              ),
              TableRow(
                children: [
                  Text('Column Spacing'),
                  TextField(controller: columnSpacingController, decoration: InputDecoration(isDense: true)),
                ],
              ),
            ],
          ),
          ElevatedButton(onPressed: () => setState(() => print(maxHeightController.text)), child: Text('update')),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: ReusableDataGrid<MapEntry<int, String>>(
              maxHeight: maxHeightController.value.text.isEmpty ? null : double.parse(maxHeightController.value.text),
              data: data,
              fields: [
                Field((x) => x.key, "key", FilterFieldNum()),
                Field((x) => x.value, "value", FilterFieldString()),
              ],
              onRowClick: (x, y) => print(x.toString()),
              lastSaveDate: dateUpdated,
              onSelectHeaderButton:
                  (x) => //
                      print(x.toString()),
              selectName: "Delete",
              fontSize: double.parse(fontSizeController.value.text),
              headerHeight: double.parse(headerHeightController.value.text),
              footerHeight: double.parse(footerHeightController.value.text),
              rowHeight: double.parse(rowHeightController.value.text),
            ),
          ),
          // Row(
          //   children: [
          //     TextButton(
          //       onPressed: () {
          //         setState(() {
          //           data = smallList;
          //           dateUpdated = DateTime.now();
          //         });
          //       },
          //       child: Text("small list"),
          //     ),
          //     TextButton(
          //       onPressed: () {
          //         setState(() {
          //           data = smallList + largeList;
          //           dateUpdated = DateTime.now();
          //         });
          //       },
          //       child: Text("full list"),
          //     ),
          //     TextButton(
          //       onPressed: () {
          //         setState(() {
          //           data = [];
          //           dateUpdated = DateTime.now();
          //         });
          //       },
          //       child: Text("no data"),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}

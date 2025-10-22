import 'dart:math';

import 'package:atreeon_datagrid_responsive/ReusableDataGridW.dart';
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
  // 9: "No checking phones for 30mins or so after I've started work, nothing but work, important time",
  // 10: "No tea after zen, quick Sainsbury's shop; disciplined for work only",
  // 11: "Don't unlock a ColdTurkeyBlock to get to one site or app, easier to remove & readd",
  // 12: "Sleep early Sunday night and prepare to work on app first thing",
  // 13: "End of day check Trello lunch, if nothing requiring work laptop then put a break for next day",
  14: "Factor in the things that might go wrong",
  15: "Keep relaxed",
  16: "Meditate daily",
  // 17: "Nothing before work",
  18: "Get to work early",
  // 19: "Check email after 4pm only",
  20: "Discipline is freedom",
  21: "Start work early",
  // 22: "Set timers for breaks",
  23: "Keep simple. More logic is more work & maintenance",
}.entries.map((e) => MapEntry(e.key, e.value)).toList();

class DataGridCheckRequirementDemo extends StatefulWidget {
  @override
  _DataGridCheckRequirementDemoState createState() => _DataGridCheckRequirementDemoState();
}

class _DataGridCheckRequirementDemoState extends State<DataGridCheckRequirementDemo> {
  var dateUpdated = DateTime.now();

  //get a random value between 1 and 1000 using random function in Dart
  var myValue = Random().nextInt(1000);

  var selected = data.where((element) => [1, 2, 4, 20].contains(element.key)).toList();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('This demo is to show that we can add a requirement in to the oncheck event.'),
          TextButton(
            onPressed: () => setState(() => //
                myValue = Random().nextInt(1000)),
            child: Text('myValue: $myValue'),
          ),
          Expanded(
            // height: 250,
            // decoration: BoxDecoration(
            // border: Border.all(color: Colors.black),
            // ),
            child: ResusableDatagridW<MapEntry<int, String>>(
              // maxHeight: 250,
              data: data,
              fields: [
                Field((x) => x.key, "key", FilterFieldNum()),
                Field((x) => x.value, "value", FilterFieldString()),
              ],
              onRowClick: (x, y) => print(x.toString()),
              lastSaveDate: dateUpdated,
              identityFieldId: Field((x) => x.key, "id", FilterFieldNum()),
              selectedIds: selected,
              onSelectHeaderButton: (x) {
                setState(() {
                  selected = [];
                  dateUpdated = DateTime.now();
                });
              },
              onCheckboxChange: (x) {
                print('from demo:' + x.toString());
                return x;
              },
              onCheckRequirement: (x) {
                print(x.length);
                return x.length < 6;
              },
              selectName: "Clear",
              fontSize: 12,
              headerHeight: 20,
              footerHeight: 20,
              rowHeight: 25,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:atreeon_datagrid_responsive/ReusableDataGrid.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/FilterField.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// {@template five_column_demo}
/// Screen that demonstrates five columns with filtering, selection, and formatting callbacks.
/// {@endtemplate}
class DataGridFiveColumnTasksDemo extends StatefulWidget {
  /// {@macro five_column_demo}
  const DataGridFiveColumnTasksDemo({super.key});

  @override
  State<DataGridFiveColumnTasksDemo> createState() => _DataGridFiveColumnTasksDemoState();
}

class _DataGridFiveColumnTasksDemoState extends State<DataGridFiveColumnTasksDemo> {
  /// Re-usable formatter for the date-based columns.
  final DateFormat _dateFormatter = DateFormat('MMM d, yyyy');

  /// Immutable list of tasks rendered in the grid.
  late final List<DemoTask> tasks;

  /// Tracks the currently selected rows to mirror the grid state.
  late List<DemoTask> selectedTasks;

  /// Timestamp used to trigger a refresh when the selection changes.
  late DateTime lastSaveDate;

  @override
  void initState() {
    super.initState();
    tasks = buildDemoTasks();
    selectedTasks = tasks.take(2).toList(growable: false);
    lastSaveDate = DateTime.now();
  }

  /// Formats an estimate in hours into a compact string label.
  String _formatEstimate(double hours) {
    final isWholeNumber = hours % 1 == 0;
    final rounded = isWholeNumber ? hours.toStringAsFixed(0) : hours.toStringAsFixed(1);
    return '${rounded}h';
  }

  /// Formats a [DateTime] for display in the grid columns.
  String _formatDate(DateTime date) => _dateFormatter.format(date);

  /// Clears all selections when the header action is invoked.
  void _handleSelectHeaderButton(List<String> _) {
    setState(() {
      selectedTasks = const <DemoTask>[];
      lastSaveDate = DateTime.now();
    });
  }

  /// Synchronizes checkbox selection changes back to the stateful demo.
  List<String> _handleCheckboxChange(List<String> ids) {
    final updatedSelection = tasks.where((task) => ids.contains(task.id)).toList(growable: false);
    setState(() {
      selectedTasks = updatedSelection;
      lastSaveDate = DateTime.now();
    });
    return ids;
  }

  /// Enforces a maximum of five selected rows to mirror the example constraint.
  bool _handleCheckRequirement(List<String> ids) => ids.length < 6;

  /// Builds the scaffold containing the five-column data grid showcase.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ReusableDataGrid<DemoTask>(
              alwaysShowFilter: true,
              data: tasks,
              fields: [
                Field((task) => task.id, 'Id', FilterFieldString()),
                Field((task) => task.name, 'Title', FilterFieldString()),
                Field((task) => task.timeEstimateHours, 'Estimate', FilterFieldNum(), format: (task) => _formatEstimate(task.timeEstimateHours)),
                Field((task) => task.startDate, 'Start Date', FilterFieldString(), format: (task) => _formatDate(task.startDate)),
                Field((task) => task.dueDate, 'Due Date', FilterFieldString(), format: (task) => _formatDate(task.dueDate)),
              ],
              onRowClick: (row, index) => debugPrint('Row ${row.id} tapped at index $index'),
              lastSaveDate: lastSaveDate,
              identityFieldId: Field((task) => task.id, 'Id', FilterFieldString()),
              selectedItems: selectedTasks,
              onSelectHeaderButton: _handleSelectHeaderButton,
              onCheckboxChange: _handleCheckboxChange,
              onCheckRequirement: _handleCheckRequirement,
              selectName: 'Clear',
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

/// Represents a lightweight task used to exercise the five-column data grid demo.
class DemoTask {
  /// Unique identifier for the task row.
  final String id;

  /// Human-readable task name displayed in the Title column.
  final String name;

  /// Estimated effort in hours for the Estimate column.
  final double timeEstimateHours;

  /// Planned start date for the Start Date column.
  final DateTime startDate;

  /// Target due date for the Due Date column.
  final DateTime dueDate;

  /// {@macro demo_task}
  const DemoTask({required this.id, required this.name, required this.timeEstimateHours, required this.startDate, required this.dueDate});
}

/// Creates stable sample tasks for the five-column demo grid.
List<DemoTask> buildDemoTasks() => <DemoTask>[
  DemoTask(id: 'AT-1001', name: 'Design responsive layout', timeEstimateHours: 4.5, startDate: DateTime(2024, 6, 10), dueDate: DateTime(2024, 6, 12)),
  DemoTask(id: 'AT-1002', name: 'Integrate authentication', timeEstimateHours: 7, startDate: DateTime(2024, 6, 11), dueDate: DateTime(2024, 6, 14)),
  DemoTask(id: 'AT-1003', name: 'Write onboarding flow', timeEstimateHours: 5, startDate: DateTime(2024, 6, 12), dueDate: DateTime(2024, 6, 15)),
  DemoTask(id: 'AT-1004', name: 'Implement analytics events', timeEstimateHours: 3.5, startDate: DateTime(2024, 6, 13), dueDate: DateTime(2024, 6, 16)),
  DemoTask(id: 'AT-1005', name: 'QA payment edge cases', timeEstimateHours: 6, startDate: DateTime(2024, 6, 14), dueDate: DateTime(2024, 6, 18)),
  DemoTask(id: 'AT-1006', name: 'Optimize startup time', timeEstimateHours: 2.5, startDate: DateTime(2024, 6, 15), dueDate: DateTime(2024, 6, 17)),
  DemoTask(id: 'AT-1007', name: 'Refresh typography scale', timeEstimateHours: 3, startDate: DateTime(2024, 6, 16), dueDate: DateTime(2024, 6, 19)),
  DemoTask(id: 'AT-1008', name: 'Ship release checklist', timeEstimateHours: 1.5, startDate: DateTime(2024, 6, 17), dueDate: DateTime(2024, 6, 19)),
];

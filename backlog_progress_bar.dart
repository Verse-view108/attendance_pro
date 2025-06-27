import 'package:flutter/material.dart';

class BacklogProgressBar extends StatelessWidget {
  final String subjectId;
  final int tasksCompleted;
  final int totalTasks;

  const BacklogProgressBar({
    required this.subjectId,
    required this.tasksCompleted,
    required this.totalTasks,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = tasksCompleted / totalTasks;
    return Card(
      child: ListTile(
        title: Text(subjectId),
        subtitle: LinearProgressIndicator(value: progress),
        trailing: Text('$tasksCompleted/$totalTasks'),
      ),
    );
  }
}

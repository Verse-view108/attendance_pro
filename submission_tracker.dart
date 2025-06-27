import 'package:flutter/material.dart';
import 'package:attendance_pro/models/assignment_model.dart';

class SubmissionTracker extends StatelessWidget {
  final Assignment assignment;

  const SubmissionTracker({required this.assignment, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(assignment.title),
        subtitle: Text('Due: ${assignment.dueDate.toString()}'),
        trailing: Text(assignment.allowResubmissions ? 'Resubmissions Allowed' : 'No Resubmissions'),
      ),
    );
  }
}

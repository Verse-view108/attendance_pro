import 'package:flutter/material.dart';
import 'package:attendance_pro/services/firestore_service.dart';
import 'package:attendance_pro/widgets/backlog_progress_bar.dart';

class BacklogProgressScreen extends StatelessWidget {
  final String studentId;

  const BacklogProgressScreen({required this.studentId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreService _firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: Text('Backlog Progress')),
      body: FutureBuilder<Map<String, int>>(
        future: _firestoreService.getBacklogTasks(studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final backlogTasks = snapshot.data ?? {};
          return ListView(
            children: backlogTasks.entries.map((entry) {
              return BacklogProgressBar(
                subjectId: entry.key,
                tasksCompleted: entry.value,
                totalTasks: 10, // Example
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

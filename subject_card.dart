import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  final String subjectId;
  final String name;

  const SubjectCard({required this.subjectId, required this.name, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text(subjectId),
      ),
    );
  }
}

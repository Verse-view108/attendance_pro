import 'package:flutter/material.dart';
import 'package:attendance_pro/models/timetable_period.dart';

class PeriodCard extends StatelessWidget {
  final TimetablePeriod period;

  const PeriodCard({required this.period, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(period.subjectId),
        subtitle: Text('${period.day} at ${period.time} in ${period.roomId}'),
      ),
    );
  }
}

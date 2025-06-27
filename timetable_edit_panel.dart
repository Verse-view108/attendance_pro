import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendance_pro/services/timetable_service.dart';
import 'package:attendance_pro/services/firestore_service.dart';
import 'package:attendance_pro/widgets/period_card.dart';

class TimetableEditPanel extends StatefulWidget {
  final String userRole;
  final String userId;
  final String? subjectId; // Nullable for professors

  const TimetableEditPanel({
    required this.userRole,
    required this.userId,
    this.subjectId,
    Key? key,
  }) : super(key: key);

  @override
  _TimetableEditPanelState createState() => _TimetableEditPanelState();
}

class _TimetableEditPanelState extends State<TimetableEditPanel> {
  final _formKey = GlobalKey<FormState>();
  String? selectedSubject, selectedRoom, selectedTime, selectedDay;
  String? availabilityMessage;
  bool isLoading = false;
  final TimetableService _timetableService = TimetableService();
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _checkAvailability() async {
    if (!_validateInputs()) return;
    setState(() => isLoading = true);
    try {
      final result = await _timetableService.checkAvailability(
        roomId: selectedRoom!,
        time: selectedTime!,
        day: selectedDay!,
        subjectId: selectedSubject!,
        userId: widget.userId,
        userRole: widget.userRole,
      );
      setState(() {
        availabilityMessage = result['message'] as String? ?? 'Error checking availability';
      });
    } catch (e) {
      setState(() {
        availabilityMessage = 'Error: $e';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _savePeriod() async {
    if (!_formKey.currentState!.validate() || !_validateInputs()) return;
    setState(() => isLoading = true);
    try {
      await _timetableService.savePeriod(
        subjectId: selectedSubject!,
        roomId: selectedRoom!,
        time: selectedTime!,
        day: selectedDay!,
        userId: widget.userId,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Period saved successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving period: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  bool _validateInputs() {
    if (selectedSubject == null || selectedRoom == null || selectedTime == null || selectedDay == null) {
      setState(() {
        availabilityMessage = 'Please select all fields';
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Timetable')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    FutureBuilder<List<String>>(
                      future: widget.userRole == 'CR'
                          ? Future.value([widget.subjectId].whereType<String>().toList())
                          : _firestoreService.getProfessorSubjects(widget.userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        return DropdownButtonFormField<String>(
                          value: selectedSubject,
                          hint: Text('Select Subject'),
                          validator: (value) => value == null ? 'Subject required' : null,
                          items: snapshot.data?.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList() ?? [],
                          onChanged: (value) => setState(() => selectedSubject = value),
                        );
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedRoom,
                      hint: Text('Select Room'),
                      validator: (value) => value == null ? 'Room required' : null,
                      items: ['LT-101', 'CS-Lab1', 'LectureHall-2'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                      onChanged: (value) => setState(() => selectedRoom = value),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedDay,
                      hint: Text('Select Day'),
                      validator: (value) => value == null ? 'Day required' : null,
                      items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                      onChanged: (value) => setState(() => selectedDay = value),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedTime,
                      hint: Text('Select Time'),
                      validator: (value) => value == null ? 'Time required' : null,
                      items: ['9:00 AM', '10:00 AM', '2:00 PM', '3:00 PM'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (value) => setState(() => selectedTime = value),
                    ),
                    ElevatedButton(
                      onPressed: _checkAvailability,
                      child: Text('Check Availability'),
                    ),
                    if (availabilityMessage != null)
                      Text(
                        availabilityMessage!,
                        style: TextStyle(color: availabilityMessage!.contains('available') ? Colors.green : Colors.red),
                      ),
                    ElevatedButton(
                      onPressed: _savePeriod,
                      child: Text('Save Period'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

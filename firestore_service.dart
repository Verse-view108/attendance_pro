import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendance_pro/models/student.dart';
import 'package:attendance_pro/models/timetable_period.dart';
import 'package:attendance_pro/models/assignment_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getProfessorSubjects(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return List<String>.from(doc.data()?['subjects'] ?? []);
    } catch (e) {
      throw Exception('Error fetching subjects: $e');
    }
  }

  Future<Map<String, int>> getBacklogTasks(String studentId) async {
    try {
      final doc = await _firestore.collection('users').doc(studentId).get();
      return Map<String, int>.from(doc.data()?['backlogTasks'] ?? {});
    } catch (e) {
      throw Exception('Error fetching backlog tasks: $e');
    }
  }

  Future<void> addAssignment(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('assignments').add(data);
    } catch (e) {
      throw Exception('Error adding assignment: $e');
    }
  }

  Future<void> savePeriod(TimetablePeriod period) async {
    try {
      await _firestore.collection('timetables').doc(period.id).set(period.toFirestore());
    } catch (e) {
      throw Exception('Error saving period: $e');
    }
  }
}

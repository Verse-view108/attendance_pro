import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_functions/firebase_functions.dart';
import 'package:attendance_pro/models/timetable_period.dart';

class TimetableService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<Map<String, dynamic>> checkAvailability({
    required String roomId,
    required String time,
    required String day,
    required String subjectId,
    required String userId,
    required String userRole,
  }) async {
    try {
      final callable = _functions.httpsCallable('checkAvailability');
      final result = await callable.call({
        'roomId': roomId,
        'time': time,
        'day': day,
        'subjectId': subjectId,
        'userId': userId,
        'userRole': userRole,
      });
      return result.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Error checking availability: $e');
    }
  }

  Future<void> savePeriod({
    required String subjectId,
    required String roomId,
    required String time,
    required String day,
    required String userId,
  }) async {
    try {
      final period = TimetablePeriod(
        id: '${subjectId}_${day}_${time}',
        subjectId: subjectId,
        roomId: roomId,
        time: time,
        day: day,
        professorId: userId,
        crIds: [],
      );
      await FirebaseFirestore.instance.collection('timetables').doc(period.id).set(period.toFirestore());
    } catch (e) {
      throw Exception('Error saving period: $e');
    }
  }
}

class TimetablePeriod {
  final String id;
  final String subjectId;
  final String roomId;
  final String time;
  final String day;
  final String professorId;
  final List<String> crIds;

  TimetablePeriod({
    required this.id,
    required this.subjectId,
    required this.roomId,
    required this.time,
    required this.day,
    required this.professorId,
    required this.crIds,
  });

  factory TimetablePeriod.fromFirestore(Map<String, dynamic> data, String id) {
    return TimetablePeriod(
      id: id,
      subjectId: data['subjectId'] ?? '',
      roomId: data['roomId'] ?? '',
      time: data['time'] ?? '',
      day: data['day'] ?? '',
      professorId: data['professorId'] ?? '',
      crIds: List<String>.from(data['crIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'subjectId': subjectId,
      'roomId': roomId,
      'time': time,
      'day': day,
      'professorId': professorId,
      'crIds': crIds,
    };
  }
}

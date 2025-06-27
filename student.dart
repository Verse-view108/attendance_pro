class Student {
  final String id;
  final String name;
  final String email;
  final String role; // student, cr, professor, admin
  final List<String> subjects;
  final Map<String, double> attendance; // subjectId -> percentage
  final Map<String, int> backlogTasks; // subjectId -> pending tasks

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.subjects,
    required this.attendance,
    required this.backlogTasks,
  });

  factory Student.fromFirestore(Map<String, dynamic> data, String id) {
    return Student(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'student',
      subjects: List<String>.from(data['subjects'] ?? []),
      attendance: Map<String, double>.from(data['attendance'] ?? {}),
      backlogTasks: Map<String, int>.from(data['backlogTasks'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'subjects': subjects,
      'attendance': attendance,
      'backlogTasks': backlogTasks,
    };
  }
}

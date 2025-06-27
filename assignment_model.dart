class Assignment {
  final String id;
  final String title;
  final String description;
  final String subjectId;
  final String semester;
  final int year;
  final DateTime dueDate;
  final List<String> tags;
  final String fileUrl;
  final bool allowResubmissions;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.subjectId,
    required this.semester,
    required this.year,
    required this.dueDate,
    required this.tags,
    required this.fileUrl,
    required this.allowResubmissions,
  });

  factory Assignment.fromFirestore(Map<String, dynamic> data, String id) {
    return Assignment(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      subjectId: data['subjectId'] ?? '',
      semester: data['semester'] ?? '',
      year: data['year'] ?? 0,
      dueDate: DateTime.parse(data['dueDate'] ?? DateTime.now().toIso8601String()),
      tags: List<String>.from(data['tags'] ?? []),
      fileUrl: data['fileUrl'] ?? '',
      allowResubmissions: data['allowResubmissions'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'subjectId': subjectId,
      'semester': semester,
      'year': year,
      'dueDate': dueDate.toIso8601String(),
      'tags': tags,
      'fileUrl': fileUrl,
      'allowResubmissions': allowResubmissions,
    };
  }
}

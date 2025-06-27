class RiskModel {
  final String studentId;
  final double riskScore;
  final Map<String, double> riskFactors; // e.g., {'attendance': 0.4, 'assignments': 0.3}

  RiskModel({
    required this.studentId,
    required this.riskScore,
    required this.riskFactors,
  });

  factory RiskModel.fromFirestore(Map<String, dynamic> data, String id) {
    return RiskModel(
      studentId: id,
      riskScore: (data['riskScore'] ?? 0.0).toDouble(),
      riskFactors: Map<String, double>.from(data['riskFactors'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'riskScore': riskScore,
      'riskFactors': riskFactors,
    };
  }
}

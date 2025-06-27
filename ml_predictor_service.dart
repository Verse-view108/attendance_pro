import 'package:cloud_firestore/cloud_firestore.dart';

class MLPredictorService {
  Future<Map<String, dynamic>> getRiskScore(String studentId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('risks').doc(studentId).get();
      return doc.data() ?? {'riskScore': 0.0, 'riskFactors': {}};
    } catch (e) {
      throw Exception('Error fetching risk score: $e');
    }
  }
}

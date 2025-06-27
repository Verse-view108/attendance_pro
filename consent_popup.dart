import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsentPopup extends StatelessWidget {
  final String userId;

  const ConsentPopup({required this.userId, Key? key}) : super(key: key);

  Future<void> _saveConsent(BuildContext context, bool consentGiven) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'consent': {
          'gdpr': consentGiven,
          'ccpa': consentGiven,
          'timestamp': DateTime.now().toIso8601String(),
        },
      });
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving consent: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Data Consent'),
      content: Text('Do you consent to the use of your data for attendance and analytics?'),
      actions: [
        TextButton(
          onPressed: () => _saveConsent(context, false),
          child: Text('Decline'),
        ),
        TextButton(
          onPressed: () => _saveConsent(context, true),
          child: Text('Accept'),
        ),
      ],
    );
  }
}

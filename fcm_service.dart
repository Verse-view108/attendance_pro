import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _fcm.subscribeToTopic(topic);
    } catch (e) {
      throw Exception('Error subscribing to topic: $e');
    }
  }

  Future<void> sendNotification(String topic, String title, String body) async {
    try {
      // Hypothetical server-side call to FCM
      await _fcm.sendMessage(topic: topic, title: title, body: body);
    } catch (e) {
      throw Exception('Error sending notification: $e');
    }
  }
}

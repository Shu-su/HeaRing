import 'package:flutter/material.dart';


class NotificationItem {
  final int recordingId;
  final String notificationId;
  final String timestamp;

  NotificationItem({
    required this.recordingId,
    required this.notificationId,
    required this.timestamp,
  });
}

class NotificationProvider with ChangeNotifier {
  List<NotificationItem> _notifications = [];

  List<NotificationItem> get notifications => _notifications;

  // FCM 알림을 받아와서 NotificationItem 추가
  void addNotification(Map<String, dynamic> data) {
    // 알림 데이터에서 필요한 항목을 추출
    final recordingId = data['recordingId'] as int;
    final notificationId = data['notificationId'] as String;
    final timestamp = data['timestamp'] as String;

    _notifications.add(
      NotificationItem(
        recordingId: recordingId,
        notificationId: notificationId,
        timestamp: timestamp,
      ),
    );
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}
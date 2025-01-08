import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RecodeProvider extends ChangeNotifier {
  RecodeProvider() {
    loadNotificationsFromLocal();  // 앱 시작 시 알림 로드
  }

  String _messageBody = "현재 외출상태가 아닙니다.";  // 기본 메시지
  String get messageBody => _messageBody;

  // 알림 데이터 리스트
  List<Map<String, dynamic>> notifications = [];

  void updateMessageBody(String title, String body) {
    // 메시지 타입에 따라 알림 본문 설정
    if (title == "외출 알림") {
      _messageBody = "외출이 감지되었습니다.";  // 외출 알림
    } else if (title == "귀가 알림") {
      _messageBody = "귀가가 감지되었습니다.";  // 귀가 알림
    } else if (title == "위험 감지") {
      _messageBody = "위험이 감지되었습니다.";  // 위험 감지 알림
    } else {
      _messageBody = body;  // 다른 알림의 body 값
    }
    notifyListeners();
  }



  // 알림 데이터 추가
  void addNotification(int recordingId, String notificationId, String timestamp) {
    notifications.add({
      'recordingId': recordingId,
      'notificationId': notificationId,
      'timestamp': timestamp,
      'isClicked': false,  // 기본 값은 클릭되지 않은 상태
    });
    notifyListeners();
    saveNotificationsToLocal();  // SharedPreferences에 저장

  }

  // 저장된 알림 불러오기
  List<Map<String, dynamic>> getNotifications() {
    return notifications;
  }

  // SharedPreferences에서 알림 데이터 불러오기
  Future<void> loadNotificationsFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedNotifications = prefs.getStringList('notifications') ?? [];
    notifications = savedNotifications.map((notification) {
      var parts = notification.split(',');
      return {
        'recordingId': int.parse(parts[0]),
        'notificationId': parts[1],
        'timestamp': parts[2],
        'isClicked': parts[3] == 'true',  // isClicked 값을 처리
      };
    }).toList();
    notifyListeners();
  }

  // new 새로 변경 알림 데이터를 SharedPreferences에 저장
  Future<void> saveNotificationsToLocal() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // 알림 데이터를 저장할 리스트 생성
      List<String> savedNotifications = notifications.map((notification) {
        return '${notification['recordingId']},${notification['notificationId']},${notification['timestamp']},${notification['isClicked'] ?? false}';
      }).toList();

      // 저장
      await prefs.setStringList('notifications', savedNotifications);

      // 디버깅용으로 저장된 데이터 출력
      print('Notifications saved: $savedNotifications');
    } catch (e) {
      // 예외 처리
      print('Failed to save notifications: $e');
    }
  }

  // new 알림 클릭 상태 업데이트 onNotificationClick() 까지 추가
  void updateNotificationStatus(int index, bool isClicked) {
    notifications[index]['isClicked'] = isClicked;

    // 변경된 알림 상태를 SharedPreferences에 저장
    saveNotificationsToLocal().then((_) {
      print('알림 클릭 상태 저장 완료');
      notifyListeners();  // 상태 변경을 알림
    }).catchError((error) {
      print('알림 상태 저장 오류: $error');
    });
  }

// 알림 클릭 시 처리
  void onNotificationClick(int index) {
    // isClicked 상태를 true로 변경하여 UI 갱신
    updateNotificationStatus(index, true);
  }




  //알림 목록 비우는
  void clearNotifications() {
    notifications.clear(); // 알림 목록 비우기
    notifyListeners(); // 상태 업데이트 알림
  }

  // 알림 수신 시 처리
  void onNotificationReceived(int recordingId, String notificationId, String timestamp) {
    addNotification(recordingId, notificationId, timestamp);  // 알림 추가 후 즉시 UI 갱신
    notifyListeners(); // 상태 변경 후 UI 갱신
  }
}


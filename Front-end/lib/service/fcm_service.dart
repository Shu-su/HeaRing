import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hearing/service/recode_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//fcm_service.dart
// FCM 초기화 함수

Future<void> initializeFCM(
    GlobalKey<NavigatorState> navigatorKey,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    BuildContext context,
    ) async {
  FirebaseMessaging fbMsg = FirebaseMessaging.instance;

  // FCM Token 가져오기
  String? fcmToken = await fbMsg.getToken();
  print("FCM 토큰: $fcmToken");

  fbMsg.onTokenRefresh.listen((newToken) {
    print("새로운 FCM 토큰: $newToken");
  });

  // Foreground 메시지 처리
  FirebaseMessaging.onMessage.listen((message) async {
    await firebaseMessagingForegroundHandler(message, flutterLocalNotificationsPlugin, navigatorKey);
  });

  // Background 메시지 처리
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // 초기 메시지 처리 (앱을 종료한 상태에서 알림 클릭 시)
  await setupInteractedMessage((String messageBody) {
    print("알림 클릭 시 받은 메시지: $messageBody");
    // 여기서 메시지 내용에 따라 추가 작업을 수행할 수 있습니다.
  }, context);
}


Future<void> firebaseMessagingForegroundHandler(
    RemoteMessage message,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    GlobalKey<NavigatorState> navigatorKey,
    ) async {
  print('[FCM - Foreground] 메시지 수신: ${message.data}');

  // 알림의 title과 body를 가져와서 messageBody를 업데이트
  if (message.notification != null) {
    String title = message.notification?.title ?? '';
    String body = message.notification?.body ?? '';
    String messageType = '알림 없음';  // 기본 메시지 타입

    // 위험 알림일 때만 message.data에서 메시지 타입을 확인
    if (message.data.isNotEmpty) {
      messageType = message.data['messageType'] ?? '알림 없음';
    }

    // RecodeProvider에서 messageBody 및 messageType 업데이트
    print('포그라운드 수신된 알림 - 제목: $title, 내용: $body');
    navigatorKey.currentContext?.read<RecodeProvider>().updateMessageBody(title, body);

    // SharedPreferences에 메시지 본문과 메시지 타입 저장
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('messageBody', body);  // 메시지 본문 저장
    await prefs.setString('messageType', messageType);  // 메시지 타입 저장
    print("SharedPreferences에 메시지 저장: 타입 - $messageType, 본문 - $body");
  }

  // recordingId 값이 유효한 정수인지 확인
  if (message.data.containsKey('recordingId')) {
    try {
      int recordingId = int.parse(message.data['recordingId']);
      String notificationId = message.data['notificationId'] ?? '0';
      String timestamp = DateTime.now().toIso8601String();

      // SharedPreferences에 알림 저장
      await saveNotificationToLocal(recordingId, notificationId, timestamp); // 수정된 함수 호출
    } catch (e) {
      print("recordingId 파싱 오류: $e");
    }
  }

  // 로컬 알림 표시
  if (message.notification != null) {
    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'important_channel', 'Important_Notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("[FCM - Background] 메시지 수신: ${message.data}");

  // messageType과 body 추출
  String title = message.notification?.title ?? '';
  String body = message.notification?.body ?? '새로운 위험 감지 알림';
  String messageType = '알림 없음';  // 기본 메시지 타입

  // 위험 알림일 때만 message.data에서 메시지 타입을 확인
  if (message.data.isNotEmpty) {
    messageType = message.data['messageType'] ?? '알림 없음';
  }

  // SharedPreferences에 메시지 본문과 메시지 타입 저장
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('messageBody', body);  // 메시지 본문 저장
  await prefs.setString('messageType', messageType);  // 메시지 타입 저장
  print("SharedPreferences에 메시지 저장: 타입 - $messageType, 본문 - $body");

  // recordingId 값이 유효한 정수인지 확인
  if (message.data.containsKey('recordingId')) {
    try {
      int recordingId = int.parse(message.data['recordingId']);
      String notificationId = message.data['notificationId'] ?? '0';
      String timestamp = DateTime.now().toIso8601String();

      // SharedPreferences에 알림 저장
      await saveNotificationToLocal(recordingId, notificationId, timestamp);
    } catch (e) {
      print("recordingId 파싱 오류: $e");
    }
  }

  // 알림 표시
  if (message.notification != null) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'important_channel', 'Important_Notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}



//SharedPreferences에 알림 메시지
Future<void> saveMessageBodyToLocal(String body) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('messageBody', body);  // 메시지 내용 저장
  print("저장된 메시지 내용: $body"); // 로그로 확인
}


// 앱이 종료된 상태에서 알림을 클릭했을 때 처리하는 함수
// 알림 클릭 처리
Future<void> setupInteractedMessage(Function(String) onMessageReceived, BuildContext context) async {
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    print("앱이 종료된 상태에서 알림을 클릭하여 열림: ${initialMessage.messageId}");

    if (initialMessage.notification?.body != null) {
      String body = initialMessage.notification!.body ?? 'No Message Body';
      onMessageReceived(body);

      // 상태 갱신
      if (context.read<RecodeProvider>() != null) {
        context.read<RecodeProvider>().updateMessageBody(initialMessage.notification!.title ?? '알림', body);
      }
    }
  }

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    if (message.notification?.body != null) {
      String body = message.notification!.body ?? 'No Message Body';
      onMessageReceived(body);

      // 상태 갱신
      if (context.read<RecodeProvider>() != null) {
        context.read<RecodeProvider>().updateMessageBody(message.notification!.title ?? '알림', body);
      }
    }
  });
}

Future<void> saveNotificationToLocal(int recordingId, String notificationId, String timestamp) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 기존 알림 목록 가져오기
    List<String> notifications = prefs.getStringList('notifications') ?? [];

    // 중복 확인 (notificationId를 기반으로)
    bool isDuplicate = notifications.any((notification) => notification.contains(notificationId));
    if (isDuplicate) {
      print("중복된 알림이므로 저장하지 않음: $notificationId");
      return; // 이미 저장된 알림이면 저장하지 않음
    }

    // 새로운 알림 데이터를 리스트에 추가
    String newNotification = '$recordingId,$notificationId,$timestamp,false'; // false는 기본값
    notifications.add(newNotification);

    // 업데이트된 알림 리스트 저장
    bool success = await prefs.setStringList('notifications', notifications);
    if (!success) {
      throw Exception("알림 데이터를 저장하는 데 실패했습니다.");
    }

    // 저장 성공 여부 로그 출력
    print('알림 데이터 저장 성공: $newNotification');
  } catch (e) {
    print("알림 저장 오류: $e");
  }
}




// SharedPreferences에서 알림 데이터를 불러오는 함수
Future<List<String>> loadNotificationsFromLocal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('notifications') ?? [];
}

// FCM 서비스에서 알림 수신 처리
class FCMService {
  static void setupFCM(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // 메시지 title과 body 가져오기
      String title = message.notification?.title ?? '알림 제목 없음';
      String body = message.notification?.body ?? '새로운 메시지 없음';

      // RecodeProvider에서 messageBody 업데이트
      context.read<RecodeProvider>().updateMessageBody(title, body);

      // 알림 데이터 처리 (recordingId, notificationId, timestamp)
      if (message.data.isNotEmpty) {
        int recordingId = int.parse(message.data['recordingId'] ?? '0');
        String notificationId = message.data['notificationId'] ?? '';
        String timestamp = message.data['timestamp'] ?? '';

        // 시간 포맷을 변환 후 저장
        context.read<RecodeProvider>().addNotification(recordingId, notificationId, timestamp);
      }
    });
  }
}

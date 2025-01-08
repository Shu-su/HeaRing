import 'package:http/http.dart' as http;
import 'dart:convert';



const String serverUrl = 'http://-/api';  // 실제 서버 주소 필요

Future<void> putReadNotification(String notificationId) async {
  final url = Uri.parse('$serverUrl/notifications/$notificationId/read');

  // 요청 헤더 설정
  final headers = {
    'Content-Type': 'application/json',
  };

  final body = json.encode({
    'notificationId': notificationId,
    'status': 0,  // 읽음 상태 (0으로 설정, 필요 시 수정)
  });

  try {
    // PUT 요청 보내기
    final response = await http.put(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('알림 읽음 상태가 성공적으로 업데이트되었습니다.');
    } else {
      print('알림 읽음 상태 업데이트 실패: ${response.statusCode}');
      print('응답 본문: ${response.body}');
    }
  } catch (e) {
    print('PUT 요청 중 오류 발생: $e');
  }
}

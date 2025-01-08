import 'package:http/http.dart' as http;
import 'dart:convert';


Future<http.Response?> updateDangerData(int recordingId) async {
  try {
    final url = Uri.parse('http://실제 서버 주소 입력/api1/recordings/recording/$recordingId');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'recordingId': recordingId.toString(), // recordingId를 String으로 변환
        'userReview': false, // boolean 값
      }),
    );

    if (response.statusCode == 200) {
      print('데이터 업데이트 완료: ${response.body}');
      return response;
    } else {
      print('데이터 업데이트 실패: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('오류 발생: $e');
    return null;
  }
}

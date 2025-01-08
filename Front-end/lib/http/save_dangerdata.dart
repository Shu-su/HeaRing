import 'package:http/http.dart' as http;
import 'dart:convert';


Future<http.Response?> saveDangerData(int recordingId, String location) async {
  try {
    final url = Uri.parse('http://실제 서버 주소 입력/api1/recordings/toHistory');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'recordingId': recordingId,  // recordingId 추가
        'location': location,        // location 추가
        'isDangerous': true,         // isDangerous = true 추가
      }),
    );

    if (response.statusCode == 200) {
      print('데이터 저장 완료: ${response.body}');
      return response; // 성공적으로 데이터를 저장한 경우
    } else {
      print('데이터 저장 실패: ${response.statusCode}');
      return null; // 실패한 경우
    }
  } catch (e) {
    print('오류 발생: $e');
    return null; // 오류가 발생한 경우
  }
}


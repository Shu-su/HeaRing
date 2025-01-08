import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';


class HistoryService {
  final String baseUrl = '서버주소/api1'; // 서버 주소
  final int deviceId = 1;

  Future<List<Map<String, dynamic>>> Alldata() async {
    final url = Uri.parse('$baseUrl/histories/device/$deviceId'); // API 주소 설정

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      }).timeout(Duration(seconds: 30));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // 서버 응답 출력

      if (response.statusCode == 200) {
        try {
          final decodedData = utf8.decode(
              response.bodyBytes); // 응답 바디를 UTF-8로 디코딩
          final jsonData = json.decode(decodedData);
          if (jsonData is List) {
            return jsonData.map((e) {
              // sentences가 null인 경우 빈 리스트로 처리
              e['sentences'] = e['sentences'] ?? [];
              return e as Map<String, dynamic>;
            }).toList();
          } else {
            throw Exception('Unexpected response format: Not a list');
          }
        } catch (e) {
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception('Failed to load history data');
      }
    } on TimeoutException catch (_) {
      throw Exception('The request timed out');
    } catch (e) {
      throw Exception('Failed to load history data: $e');
    }
  }

  Future<Map<String, dynamic>> detaildata(int historyId) async {
    final url = Uri.parse('$baseUrl/histories/$historyId'); // API 주소 설정

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json; charset=UTF-8', // UTF-8 인코딩 설정
      }).timeout(Duration(seconds: 10)); // 10초 타임아웃 설정

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // 서버 응답 출력 (한국어 포함)

      if (response.statusCode == 200) {
        try {
          final decodedData = utf8.decode(response.bodyBytes); // UTF-8 디코딩
          final jsonData = json.decode(decodedData);

          print('Decoded JSON Data: $jsonData'); // 디코딩된 JSON 데이터 출력 (한국어 포함)

          if (jsonData is Map<String, dynamic>) {
            return {
              'historyId': jsonData['historyId'] ?? 1,
              'filepath': jsonData['filepath'] ?? '',
              'timestamp': jsonData['timestamp'] ?? '',
              'location': jsonData['location'] ?? '',
              'sentences': jsonData['text'] is List ? jsonData['text'] : [jsonData['text'] ?? ''],
            };
          } else {
            throw Exception('Unexpected response format: Not a map');
          }
        } catch (e) {
          print('Error parsing response: $e');
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception(
            'Failed to load detail data. Status code: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      throw Exception('The request timed out');
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load detail data: $e');
    }
  }
}
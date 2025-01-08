import 'dart:convert';
import 'package:http/http.dart' as http;



Future<String?> getAddress(double latitude, double longitude) async {
  // 네이버 API 클라이언트 ID와 클라이언트 시크릿
  final String clientId = '실제 Client ID 입력';  // 네이버 클라우드에서 발급받은 Client ID
  final String clientSecret = '실제 Client Secret 입력';  // 네이버 클라우드에서 발급받은 Client Secret

  // API URL 구성 (네이버 Reverse Geocoding API)
  final url =
      '네이버 Reverse Geocoding API URL 입력';

  // API 호출
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': clientId,
        'X-NCP-APIGW-API-KEY': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      // 응답을 성공적으로 받았을 때
      final data = jsonDecode(response.body);

      if (data['results'] != null && data['results'].isNotEmpty) {
        // 도로명 주소가 있을 때 추출
        final roadAddressData = data['results']
            .firstWhere((result) => result['name'] == 'roadaddr', orElse: () => null);

        if (roadAddressData != null) {
          // 도로명 주소 상세 정보 추출
          final area1 = roadAddressData['region']['area1']['name'] ?? '';
          final area2 = roadAddressData['region']['area2']['name'] ?? '';
          final area3 = roadAddressData['region']['area3']['name'] ?? '';
          final roadName = roadAddressData['land']['name'] ?? '';
          final buildingNumber = roadAddressData['land']['number1'] ?? '';

          // 전체 도로명 주소 구성
          return "$area1 $area2 $area3 $roadName $buildingNumber";
        }

        // 지번 주소를 대체로 사용 (도로명 주소가 없는 경우)
        final jibunAddressData = data['results']
            .firstWhere((result) => result['name'] == 'addr', orElse: () => null);

        if (jibunAddressData != null) {
          final area1 = jibunAddressData['region']['area1']['name'] ?? '';
          final area2 = jibunAddressData['region']['area2']['name'] ?? '';
          final area3 = jibunAddressData['region']['area3']['name'] ?? '';
          final landName = jibunAddressData['land']['name'] ?? '';
          final landNumber = jibunAddressData['land']['number1'] ?? '';

          return "$area1 $area2 $area3 $landName $landNumber";
        }

        return '도로명 주소를 찾을 수 없습니다.';
      } else {
        return '주소를 찾을 수 없습니다.';
      }
    } else {
      return '주소를 불러오지 못했습니다. (HTTP ${response.statusCode})';
    }
  } catch (e) {
    // 에러 발생 시 처리
    print('Error fetching address: $e');
    return '주소를 불러오는 중 오류가 발생했습니다.';
  }
}

import 'package:http/http.dart' as http;
import 'dart:convert';

// getData 함수: recordingId를 int로 받아서 해당 데이터를 서버에서 요청
Future<RecordingId?> getData(int recordingId) async {
  try {
    final url = Uri.parse('----/recordings/recording/$recordingId'); // 진짜 서버주소 필요
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // 서버에서 받은 응답 데이터를 UTF-8로 디코딩
      print('Response body: ${utf8.decode(response.bodyBytes)}');  // 응답 데이터를 UTF-8로 디코딩한 후 출력
      return RecordingId.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));  // JSON을 Dart 객체로 변환
    } else {
      print('Failed to load recording data. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;  // 예외 처리
  }
}


class RecordingId {
  final int? recordingId;
  final Recording recording;
  final Device device;  // Device 필드를 추가

  RecordingId({
    this.recordingId,
    required this.recording,
    required this.device,  // device도 생성자에서 받아야 함
  });

  // JSON을 파싱할 때 'device'와 'recording' 모두 파싱
  factory RecordingId.fromJson(Map<String, dynamic> json) => RecordingId(
    recordingId: json["recording"]["recordingId"] != null ? json["recording"]["recordingId"] as int : null,
    recording: Recording.fromJson(json["recording"]),
    device: Device.fromJson(json["device"] ?? {}),  // 'device' 정보도 파싱
  );

  Map<String, dynamic> toJson() => {
    "recordingId": recordingId,
    "recording": recording.toJson(),
    "device": device.toJson(),  // 'device' 정보를 JSON으로 변환
  };
}


// Device 모델 클래스
class Device {
  int deviceId;
  String deviceName;
  String address;

  Device({
    required this.deviceId,
    required this.deviceName,
    required this.address,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    print("Parsing Device JSON: $json");  // 디버깅용 출력

    // json["device"]가 null이거나 비어있다면 디폴트 값을 사용
    return Device(
      deviceId: json["deviceId"] ?? 2,  // 기본값 2
      deviceName: json["deviceName"] ?? 'Unknown',  // 기본값 'Unknown'
      address: json["address"] ?? 'Unknown',  // 기본값 'Unknown'
    );
  }

  Map<String, dynamic> toJson() => {
    "deviceId": deviceId,
    "deviceName": deviceName,
    "address": address,
  };
}

// Recording 모델 클래스
class Recording {
  String timestamp;
  double? latitude;
  double? longitude;
  List<String> text;
  String filepath;
  Device device;

  Recording({
    required this.timestamp,
    this.latitude,
    this.longitude,
    required this.text,
    required this.filepath,
    required this.device,
  });

  factory Recording.fromJson(Map<String, dynamic> json) {
    print("Parsing Recording JSON: $json");  // 디버깅용 출력
    print("Device JSON: ${json["device"]}");
    return Recording(
      timestamp: json["timestamp"] ?? 'N/A',
      latitude: json["latitude"] != null ? json["latitude"].toDouble() : null,
      longitude: json["longitude"] != null ? json["longitude"].toDouble() : null,
      text: List<String>.from(json["text"] ?? []),
      filepath: json["filepath"] ?? '',
      device: Device.fromJson(json["device"] ?? {}),  // device가 없으면 빈 Map으로 처리
    );
  }

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp,
    "latitude": latitude,
    "longitude": longitude,
    "text": text,
    "filepath": filepath,
    "device": device.toJson(),
  };
}

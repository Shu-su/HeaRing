import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:hearing/http/get_dangerdata.dart';

class DangerGPSWidget extends StatefulWidget {
  const DangerGPSWidget({Key? key, required this.recordingId}) : super(key: key);

  final String recordingId;

  @override
  State<DangerGPSWidget> createState() => _DangerGPSWidgetState();
}

class _DangerGPSWidgetState extends State<DangerGPSWidget> {
  Future<RecordingId?>? _recordingFuture;
  late NaverMapController mapController;

  @override
  void initState() {
    super.initState();

    // recordingId를 int로 변환하여 getData 함수 호출
    int parsedRecordingId = int.tryParse(widget.recordingId) ?? 0;  // String을 int로 변환
    _recordingFuture = getData(parsedRecordingId);  // int 타입으로 전달
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RecordingId?>(
      future: _recordingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          final recording = snapshot.data!;
          final latitude = recording.recording.latitude;
          final longitude = recording.recording.longitude;

          if (latitude == null || longitude == null) {
            return Center(child: Text('유효한 GPS 데이터가 없습니다.'));
          }

          return SizedBox(
            width: 400,
            height: 300,
            child: NaverMap(
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: NLatLng(latitude, longitude),  // 여기서 double?을 double로 안전하게 사용
                  zoom: 16,
                ),
              ),
              onMapReady: (controller) async {
                mapController = controller;
                final marker = NMarker(
                  id: "danger_marker",
                  position: NLatLng(latitude, longitude),  // 여기서도 double?을 double로 안전하게 사용
                );
                mapController.addOverlay(marker);
              },
            ),
          );
        } else {
          return Center(child: Text('GPS 데이터가 없습니다.'));
        }
      },
    );
  }
}

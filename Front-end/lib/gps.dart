import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class Gps extends StatefulWidget {
  const Gps({Key? key}) : super(key: key);

  @override
  State<Gps> createState() => _GpsState();
}

class _GpsState extends State<Gps> {
  late final NaverMapController mapController;
  late final WebSocketChannel channel;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isCommunicating = false; // 통신 상태를 나타내는 변수
  double latitude = 37.5586668; // 위도 기본값 설정
  double longitude = 127.0498872; // 경도 기본값 설정
  NMarker? currentMarker; // 현재 위치 마커

  @override
  void initState() {
    super.initState();

    // WebSocket 연결 시작
    channel = IOWebSocketChannel.connect('--'); // 진짜 wss 주소 필요

    // WebSocket 연결 시 첫 메시지 전송
    channel.sink.add(json.encode({"clientId": "ANDROID"}));

    setState(() {
      isCommunicating = true; // 통신 상태를 true로 설정
    });

    // WebSocket 데이터 수신 처리
    channel.stream.listen((data) {
      try {
        print('받은 데이터: $data');
        Map<String, dynamic> parsedData = json.decode(data);

        // 위도와 경도 처리
        if (parsedData.containsKey('latitude') &&
            parsedData.containsKey('longitude')) {
          setState(() {
            latitude = (parsedData['latitude'] as num).toDouble();
            longitude = (parsedData['longitude'] as num).toDouble();
          });

          // 지도에 마커 추가
          mapController.clearOverlays(); // 모든 오버레이 제거

          // 새로운 마커 추가
          currentMarker = NMarker(
            id: "Marker", // 고유 ID
            position: NLatLng(latitude, longitude),
            caption: NOverlayCaption(text: "현재 위치"), // 마커의 캡션 설정
          );

          mapController.addOverlay(currentMarker!);
        }
      } catch (e) {
        print('데이터 처리 중 오류 발생: $e');
      }
    }, onError: (error) {
      print('WebSocket 오류: $error');
    });
  }

  @override
  void dispose() {
    // WebSocket 연결 종료
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(latitude, longitude),
                zoom: 15, // 기본 줌 레벨 설정
              ),
            ),
            onMapReady: (controller) {
              mapController = controller;
            },
          ),
          if (isCommunicating)
            Positioned(
              top: 20,
              left: 20,
              child: const Text(
                '통신중...',
                style: TextStyle(fontSize: 25, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}






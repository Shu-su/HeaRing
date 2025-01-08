import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

//위젯
import 'package:hearing/widget/danger_widget.dart';
import 'package:hearing/widget/danger_fin_widget.dart';
import 'package:intl/intl.dart';

//페이지
import 'package:hearing/gps.dart';
import 'package:hearing/recode.dart';

//위험상황데이터
import 'package:hearing/http/reverse_geocoding.dart';
import 'package:hearing/http/get_dangerdata.dart';



class DangerPage extends StatefulWidget {
  const DangerPage({Key? key}) : super(key: key);

  @override
  _DangerPageState createState() => _DangerPageState();
}

class _DangerPageState extends State<DangerPage> {
  late RecordingId recordingData;
  late int? currentRecordingId;
  late String filepath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 전달된 데이터 받기
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is RecordingId) {  // 타입 체크
      setState(() {
        recordingData = args;
        currentRecordingId = recordingData.recordingId;  // nullable로 처리
        filepath = recordingData.recording.filepath ?? '';  // filepath 설정
      });
    } else {
      // 데이터가 전달되지 않거나 올바르지 않은 경우에 대한 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('잘못된 데이터가 전달되었습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFB0B0), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: buildContent(recordingData),
        ),
      ),
    );
  }

  Widget buildContent(RecordingId recording) {
    final latitude = recording.recording.latitude ?? 0.0;
    final longitude = recording.recording.longitude ?? 0.0;

    // 주소를 가져오는 Future 생성, 리버스 지오코딩 진행
    Future<String?> addressFuture = getAddress(latitude, longitude);

    return FutureBuilder<String?>(
      future: addressFuture,
      builder: (context, snapshot) {
        // 데이터가 로딩 중일 때 처리
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // 로딩 스피너 표시
        }
        // 에러 발생 시 처리
        if (snapshot.hasError) {
          return Center(
            child: Text(
              '주소를 불러오는 중 에러가 발생했습니다. : ${snapshot.error}',
              textAlign: TextAlign.center,
            ),
          );
        }


        // 정상적인 경우
        String address = snapshot.data ?? '주소를 찾을 수 없음';


        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text( recordingData.device.deviceName,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w700),
                    ),
                  ),

                  Expanded(
                    child: Text(
                      formatTimestamp(recording.recording.timestamp ?? '시간 정보 없음'),
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Color(0xFF48493F), fontSize: 13),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "발화위치가 표시됩니다.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFF48493F),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 400,
              height: 300,
              child: Stack(
                children: [
                  NaverMap(
                    options: NaverMapViewOptions(
                      initialCameraPosition: NCameraPosition(
                        target: NLatLng(latitude, longitude),
                        zoom: 16,
                      ),
                    ),
                    onMapReady: (controller) {
                      print("네이버 맵 로딩됨!");

                      final marker = NMarker(
                        id: "danger_marker",
                        position: NLatLng(latitude, longitude),
                      );
                      controller.addOverlay(marker); // 지도에 마커 추가
                    },
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(width: 400, height: 80),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '발화 위치:',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Color(0xFF48493F), fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    address,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Color(0xFF48493F), fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            DangerWidget(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '위험으로 감지된 문장',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF48493F)),
                  ),
                  SizedBox(height: 5),
                  Text(
                    recording.recording.text.join(', ') ?? '위험 문장 정보 없음', // text 리스트 처리
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Recode(filepath: filepath),
                  ),
                );
              },
              child: DangerWidget(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '녹음 듣기',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 5),
                    const Text(
                      '위험 감지 시점의 녹음을 들을 수 있습니다.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF48493F)),
                    ),
                  ],
                ),
              ),
            ),


            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Gps()));
              },
              child: DangerWidget(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('GPS', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                    SizedBox(height: 5),
                    Text('착용자의 현재 위치를 볼 수 있어요', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF48493F)))])),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 0),
              child: ElevatedButton(
                onPressed: () {
                  if (currentRecordingId != null) {  // nullable 체크
                    showDangerFinDialog(context, currentRecordingId!, address);  // non-null assertion
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('RecordingId가 없습니다.')));
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '위험 상황 종료하기',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// timestamp 포멧 진행
String formatTimestamp(String timestamp) {
  try {
    // 'KST', 'AM', 'PM', 'am', 'pm' 모두 제거하고 공백을 정리합니다.
    timestamp = timestamp.replaceAll(RegExp(r'KST|am|pm|AM|PM', caseSensitive: false), '').trim();

    // '2024-11-20 17:56:52' 형식으로 공백을 하나로 정리합니다.
    timestamp = timestamp.replaceAll(RegExp(r'\s+'), ' ');

    // 'yyyy-MM-dd HH:mm:ss' 형식으로 변환을 시도합니다.
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(timestamp);

    // 24시간 형식으로 변환 후 원하는 형식으로 포맷
    return DateFormat("yyyy년 MM월 dd일 HH:mm").format(dateTime);
  } catch (e) {
    print('Error formatting timestamp: $e');
    return '시간 정보 없음';  // 포맷팅 실패 시 기본값 반환
  }
}




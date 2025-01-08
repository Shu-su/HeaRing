import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'widget/main_widget.dart';

import 'package:hearing/history.dart';

//ICT 10월 29일 test 용
import 'package:hearing/1029_ICT_test/test_gps.dart';
import 'package:hearing/1029_ICT_test/test_danger.dart';


class MainTestPage extends StatefulWidget {
  final String title;

  const MainTestPage({Key? key, required this.title}) : super(key: key);

  @override
  _MainTestPageState createState() => _MainTestPageState();
}

class _MainTestPageState extends State<MainTestPage> {
  String messageTitle = 'No Message Title';
  String messageBody = '현재 외출상태가 아닙니다.';

  @override
  void initState() {
    super.initState();
    // 알림 리스너 설정
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        messageTitle = message.notification?.title ?? 'No Message Title';
        messageBody = message.notification?.body ?? '현재 외출상태가 아닙니다.'; // 알림 수신 시 변경
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 200,
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFD0DD97),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(2, 4),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // 텍스트 가운데 정렬
                children: <Widget>[
                  const Text(
                    '엄 마',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "기기 번호 : device_1",
                    style: TextStyle(color: Color(0xFF48493F), fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    messageBody, // 변경된 부분: 메시지 본문 사용
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // 텍스트와 버튼들 간의 간격 조절
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DangerPage(),
                        ),
                      );
                    },
                    child: MainWidget_mini(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '위험상황으로 돌아가기',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '가장 최근 위험 상황으로 돌아가요.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF48493F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      // 데이터 없이 HistoryPage로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryPage(),
                        ),
                      );
                    },
                    child: MainWidget_mini(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '이전기록 다시보기',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '저장했던 녹음과 날짜, 발화위치를 확인할 수 있어요',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF48493F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10), // 각 버튼 간의 간격 조절
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Gps()),
                      );
                    },
                    child: MainWidget_mini(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'GPS',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '착용자의 현재 위치를 볼 수 있어요.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF48493F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




import 'package:flutter/material.dart';
import 'package:hearing/src/init/main_widget.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String messageBody = '현재 외출상태가 아닙니다.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title),
        automaticallyImplyLeading: false,
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
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  // messageBody 텍스트를 그대로 출력
                  Text(
                    messageBody,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Additional buttons and widgets can be added here
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
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
                    onTap: () {},
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
                    onTap: () {},
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

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widget/main_widget.dart';
import 'package:hearing/widget/main_notificationlist.dart';
import 'package:hearing/history.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

//danger
import 'package:hearing/danger.dart';

//gps
import 'package:hearing/gps.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//알람 파이어베이스
import "package:firebase_core/firebase_core.dart";


//서비스
import 'package:hearing/service/fcm_service.dart';
import 'package:provider/provider.dart';
import 'package:hearing/service/recode_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp();

  // Firebase Analytics 초기화
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // 네이버 SDK 초기화
  await NaverMapSdk.instance.initialize(
    clientId: '--', // 실제 클라이언트 ID로 교체
  );

  // 앱 실행
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            RecodeProvider provider = RecodeProvider();
            provider.loadNotificationsFromLocal(); // SharedPreferences에서 저장된 알림 로드
            return provider;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // FCM 초기화 코드 추가
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializeFCM(navigatorKey, flutterLocalNotificationsPlugin, context);

    return MaterialApp(
      title: '헤아링',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '헤아링 홈'),
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/danger': (context) => DangerPage(),
        '/history': (context) => HistoryPage(),
        '/main': (context) => const MyHomePage(title: '헤아링 홈'),
      },
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMessageBody();
    FCMService.setupFCM(context); // FCM 설정 함수 호출
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 앱이 포그라운드로 돌아왔을 때 상태 업데이트
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadMessageBody();
    }
  }


  Future<void> _loadMessageBody() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? body = prefs.getString('messageBody');
    String? messageType = prefs.getString('messageType');  // 메시지 타입 읽기

    // 메시지 본문이 null이거나 빈 값일 경우, 기본값을 설정
    if (body == null || body.isEmpty) {
      print("저장된 메시지가 없어 기본 메시지 표시");
      context.read<RecodeProvider>().updateMessageBody("알림 없음", "");  // 기본 메시지 설정
    } else {
      // 저장된 메시지가 있을 경우, 메시지 타입과 본문을 업데이트
      print("SharedPreferences에서 불러온 메시지 타입: $messageType, 본문: $body");
      context.read<RecodeProvider>().updateMessageBody(messageType ?? "알림 없음", body);  // 타입도 포함하여 UI 업데이트
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Consumer<RecodeProvider>(
        builder: (context, recodeProvider, child) {
          return Center(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        '엄 마',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // RecodeProvider의 messageBody를 표시
                      Text(
                        recodeProvider.messageBody,
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          // 알림 목록을 로드하고 갱신
                          final recodeProvider = Provider.of<RecodeProvider>(context, listen: false);

                          await recodeProvider.loadNotificationsFromLocal();
                          print('알림 목록 로드 완료'); // 알림 목록 로드 확인용 출력

                          showNotificationList(context, navigatorKey);
                          print('알림 목록 표시 완료'); // // 알림 목록 표시 확인용 출력
                        },
                        child: const MainWidget_mini(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '위험상황으로 돌아가기',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w700),
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistoryPage(),
                            ),
                          );
                        },
                        child: const MainWidget_mini(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '이전기록 다시보기',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w700),
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
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Gps()),
                          );
                        },
                        child: const MainWidget_mini(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GPS',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w700),
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
          );
        },
      ),
    );
  }
}
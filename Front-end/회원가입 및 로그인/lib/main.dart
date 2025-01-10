import 'package:flutter/material.dart';
import 'package:hearing/src/app.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hearing/src/init/init_start_page.dart';
import 'package:hearing/src/init/joinComplete.dart';
import 'package:hearing/src/init/joinPage.dart';
import 'package:hearing/src/init/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

late SharedPreferences prefs; // 이걸 통해 값을 저장, 관리할 수 있음 (앱이 재실행되어도)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 파이어베이스 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // SharedPreferences 초기화
  prefs = await SharedPreferences.getInstance(); // 이 함수를 통해 Shared_pre 사용

  // 앱 실행
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '헤아링 앱 로그인 회원가입 첫화면',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      // 초기페이지를 설정 (앱을 처음 시작했을 때 보여줄 경로)

      routes: {
        '/join': (context) => joinPage(),
        '/login': (context) => loginPage(),
        '/init': (context) => InitStartPage(),
        '/qr': (context) => BarcodeScanExample(),
        '/home': (context) => MyHomePage(title: '헤아링 홈'),
        '/joinComplete': (context) => CompletePage(),
      },

      getPages: [
        // 이 옵션을 이용해서 라우트 구성
        GetPage(name: '/', page: () => const App()),
        // name : 라우트 경로 정의, page : 정의한 라우트 경로로 접근했을 때 화면에 보여줄 위젯 페이지를 정의
      ],

      // 달력 한국어 출력을 위해 넣음
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),
      ],
    );
  }
}

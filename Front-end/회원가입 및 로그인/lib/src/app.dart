import 'package:hearing/main.dart';
import 'package:flutter/material.dart';
import 'package:hearing/src/init/init_start_page.dart';
import 'package:hearing/src/init/loginPage.dart';
  
class App extends StatefulWidget {  // 1. 상태 변화를 반영하여 화면을 갱신하기 위해 StatefulWidget
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late bool isInitStarted;  // 앱이 처음 실행되는지 판단하는 값

  @override
  void initState() {
    super.initState();
    isInitStarted = prefs.getBool('isInitStarted') ?? true;
    // 저장된 불값 불러오기. 앱이 처음 실행된 상태라면 값이 존재하지 않으므로 null --> true가 됨
  }

  @override
  Widget build(BuildContext context) {
    return isInitStarted ? const InitStartPage() : const loginPage();
    // isInitStarted 값에 따라 초기 페이지 또는 로그인페이지 표시
  }
}
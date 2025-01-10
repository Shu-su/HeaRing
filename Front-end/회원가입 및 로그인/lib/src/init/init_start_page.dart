import 'package:flutter/material.dart';
import 'package:hearing/src/theme/MyColors.dart';
import 'package:hearing/src/init/joinPage.dart';

class InitStartPage extends StatelessWidget {
  const InitStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenStyle1,
      body:
        Column( // 두 개의 레이아웃을 세로로 배치
        // 1. 헤아링 설명
        children: [
          SizedBox(height: 150),  // 사이즈 조절을 위해 넣음
          Expanded( // 첫 번째 Container는 화면에 꽉 차도록
            child: Container(
              child: Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                    Text('아무도 없는', style: TextStyle(fontFamily: "Giju", fontSize: 30, color: Colors.white)),
                    Text('그때에도', style: TextStyle(fontFamily: "Giju", fontSize: 30, color: Colors.white)),
                    Text('당신 곁에', style: TextStyle(fontFamily: "Giju", fontSize: 30, color: Colors.white)),
                    Image.asset(
                        'assets/initlogo.png', width: 160, height: 160, fit: BoxFit.contain),
                    SizedBox(height: 13),
                    Text('헤아Ring', style: TextStyle(fontFamily: "Giju", fontSize: 55, color: greenStylePoint)),
                    Padding(padding: EdgeInsets.all(15)),
                    ],
                ),
              ),
            ),
          ),
          // 2. 회원가입 & 로그인 버튼
          Container(
            child: Column(
              children: <Widget> [
                Padding(padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                          child: ElevatedButton(
                              child: const Text('회원가입', style: TextStyle(fontSize:22, color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(500, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11.0),
                                ),
                                backgroundColor: greenStyle2,
                              ),
                              onPressed: (){
                                Navigator.of(context).pushNamed('/join'); // 회원가입 페이지로 이동
                              }
                          ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(30, 20, 30, 5),
                    child: ElevatedButton(
                        child: const Text('로그인', style: TextStyle(fontSize:22, color: greenStyle2)),
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(500, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11.0),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: (){
                          Navigator.of(context).pushNamed('/login'); // 로그인 페이지로 이동
                        }
                    ),
                  ),
              ]
            ),
          ),
          SizedBox(height: 60), // 하단에서 50만큼 떨어뜨립니다.
        /// ================
        ],),
    );
  }
}

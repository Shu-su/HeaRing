import 'package:flutter/material.dart';
import 'package:hearing/src/theme/MyColors.dart';

class loginPage extends StatelessWidget {
  const loginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: greenStyle2),
        title: const Text(
          '로그인',
          style: TextStyle(
            color: greenStyle2,
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,  // 키보드가 올라올 때 자동으로 밀림
      body: SingleChildScrollView( // 스크롤 가능하게 감싸기
        child : Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 150.0, 20.0, 20.0), // 상단 여백 추가
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Column을 위로 정렬
            children: <Widget>[
              SizedBox(height: 10),
              Image.asset(
                  'assets/initlogo.png', width: 160,
                  height: 140,
                  fit: BoxFit.contain),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  hintText: '아이디 입력',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
              const SizedBox(height: 13),
              SizedBox(height: 20),
              TextField(
                obscureText: true, // 비밀번호 가리기
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  hintText: '비밀번호 입력',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  child: Text(
                      '로그인', style: TextStyle(fontSize: 17, color: Colors.white)),
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor: greenStyle2,
                    fixedSize: const Size(100, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/home'); //홈 페이지로 이동
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hearing/src/theme/MyColors.dart';

class CompletePage extends StatelessWidget {
  const CompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: greenStyle2),
        title: const Text(
          '회원가입 완료',
          style: TextStyle(
            color: greenStyle2,
          ),
        ),
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start, // 전체적으로 왼쪽 정렬
            children: [
              SizedBox(height: 120),
              Text('회원가입 성공!', style: TextStyle(fontSize: 32, color: greenStylePoint)),
              SizedBox(height: 20),
              Image.asset(
                  'assets/congu.gif', width: 180, height: 180, fit: BoxFit.contain),
              SizedBox(height: 50),
              Text('이제부터', style: TextStyle(fontSize: 25, color: greenStyle2)),
              Text('헤아Ring이', style: TextStyle(fontSize: 25, color: greenStyle2)),
              Text('당신을 지켜드릴게요', style: TextStyle(fontSize: 25, color: greenStyle2)),
              const SizedBox(height: 60),
              ElevatedButton(
                  child: Text('로그인하러 가기', style: TextStyle(fontSize:17 ,color: Colors.white)),
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor: greenStylePoint,
                    fixedSize: const Size(170, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11.0),
                    ),
                  ),
                  onPressed: (){
                    Navigator.of(context).pushNamed('/login'); //홈 페이지로 이동
                  }
              ),
            ],
          ),
        ),
      ),

    );
  }
}

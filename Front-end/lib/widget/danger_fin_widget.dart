import 'package:flutter/material.dart';
import 'package:hearing/http/update_dangerdata.dart';
import 'package:hearing/http/save_dangerdata.dart';
//
void showDangerFinDataDialog(BuildContext context, int recordingId, String address) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          '실제 위험 상태 였나요?',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '※ 실제 위험 상태 였을 시, 데이터가 저장되며 \n    이전기록 다시 듣기에서 확인 가능합니다.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  // '네' 버튼 클릭 시 save_dangerdata 호출
                  final response = await saveDangerData(recordingId, address);

                  // 저장 요청 후 메시지 표시
                  if (response != null && response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('데이터 저장 완료!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('저장 실패: ${response?.statusCode ?? 'Unknown error'}')),
                    );
                  }
                  // context가 여전히 유효한지 확인하고 Navigator 호출
                  // 200ms 후 내비게이션 호출
                  Future.delayed(Duration(milliseconds: 200), () {
                    if (context.mounted) {
                      Navigator.pop(context); // 팝업 닫기
                      Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false); // 새 화면으로 이동
                    }
                  });
                },
                child: Text(
                  '네',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(width: 20),
              TextButton(
                onPressed: () async {
                  // 삭제 요청 보내기
                  final response = await updateDangerData(recordingId);

                  // 삭제 요청 후 메시지 표시
                  if (response != null && response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('데이터 삭제 완료!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('삭제 실패: ${response?.statusCode ?? 'Unknown error'}')),
                    );
                  }
                  Navigator.pop(context); // 팝업 닫기
                  Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
                },
                child: Text(
                  '아니오',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

void showDangerFinDialog(BuildContext context, int recordingId, String address) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          '잠깐!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '정말로 위험 상황을 종료하시나요?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 첫 번째 팝업 닫기
                  showDangerFinDataDialog(context, recordingId, address); // 두 번째 팝업 표시
                },
                child: Text(
                  '네',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(width: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  '아니오',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}


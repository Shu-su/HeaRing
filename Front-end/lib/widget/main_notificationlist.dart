import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hearing/service/recode_provider.dart';
import 'package:hearing/http/get_dangerdata.dart';
import 'package:hearing/http/put_readnoti.dart';
import 'package:shared_preferences/shared_preferences.dart';


//main_notification.dart
//알림 목록

void showNotificationList(BuildContext context, GlobalKey<NavigatorState> navigatorKey) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text('알림 목록', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        content: Consumer<RecodeProvider>(
          builder: (context, recodeProvider, child) {
            if (recodeProvider.notifications.isEmpty) {
              return Center(
                child: Text('알림이 존재하지 않습니다.', style: TextStyle(fontSize: 16, color: Colors.grey)),
              );
            }

            return Container(
              width: double.maxFinite, // 알림 목록의 너비를 최대한 늘림
              height: MediaQuery.of(context).size.height * 0.5, // 화면 크기에 비례하는 높이 설정
              child: ListView.builder(  // ListView.builder로 스크롤 가능하게 만듦
                itemCount: recodeProvider.notifications.length,
                itemBuilder: (context, index) {
                  var notification = recodeProvider.notifications[index];
                  bool isClicked = notification['isClicked'] ?? false;

                  return GestureDetector(

                    onTap: () async {
                      // 알림 클릭 후 상태 업데이트
                      recodeProvider.onNotificationClick(index);  // 새로 추가 클릭 시 isClicked 업데이트

                      // recordingId와 notificationId 가져오기 (recordingId는 int로 변환)
                      int recordingId = (notification['recordingId'] as num).toInt(); // 소수점 제거
                      String notificationId = notification['notificationId'];

                      try {
                        // recordingId로 데이터를 요청
                        RecordingId? recordingData = await getData(recordingId);

                        if (recordingData != null) {
                          // 알림 읽음 처리
                          await putReadNotification(notificationId);

                          // 후속 처리 및 DangerPage로 이동
                          await navigatorKey.currentState?.pushNamed('/danger', arguments: recordingData);
                          Navigator.pop(context); // DangerPage로 이동 후 목록 화면 닫기
                        } else {
                          throw Exception('녹음 데이터를 불러오는 데 실패했습니다.');
                        }
                      } catch (e) {
                        print('오류 발생: $e');
                        Future.microtask(() {
                          // 오류 메시지를 보여주는 Snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('알림을 처리하는 도중 오류가 발생했습니다.')),
                          );
                        });
                      }
                    },


                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      height: 70,
                      color: isClicked ? Colors.white : const Color(0xA8CFDDFF),
                      child: Column(  // Column으로 변경하여 두 줄로 배치
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 첫 번째 줄 (timestamp 표시)
                          // timestamp를 DateTime으로 변환 후, 포맷하여 출력
                          Text(
                            '${formatTimestamp(notification['timestamp'])}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isClicked ? Colors.grey[400] : Colors.black,
                            ),
                          ),
                          // 두 번째 줄 (Recording ID | Notification ID 표시)
                          Text(
                            '${notification['recordingId']} | ${notification['notificationId']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: isClicked ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),actions: [
        // "알림 모두 삭제" 버튼
        TextButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear(); // 모든 데이터 삭제
            Provider.of<RecodeProvider>(context, listen: false).clearNotifications(); // 상태 업데이트
            Navigator.of(context).pop(); // 알림창 닫기
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('모든 알림이 삭제되었습니다.')),
            );
          },
          child: Text('알림 모두 삭제', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('닫기', style: TextStyle(color: Colors.blue)),
        ),
      ],
      );
    },
  );
}

// timestamp 포맷 함수
// 2024-11-23T21:36:04.420932
String formatTimestamp(String timestamp) {
  try {
    // 타임스탬프가 소수점 이하 부분을 포함할 경우 이를 제거
    if (timestamp.contains('.')) {
      timestamp = timestamp.split('.').first;  // 소수점 이하 부분 제거
    }

    print("Cleaned timestamp: $timestamp");  // 디버깅용 출력

    // ISO 8601 형식에서 소수점 이하 부분이 제거된 타임스탬프 파싱
    DateTime parsedDate = DateTime.parse(timestamp);

    // 원하는 출력 형식으로 변환
    String formattedDate = DateFormat('yyyy년 MM월 dd일 HH:mm').format(parsedDate);
    return formattedDate;
  } catch (e) {
    print('Timestamp format error: $e');
    // 파싱 오류 발생 시 기본 문자열 반환
    return '잘못된 시간 형식';
  }
}


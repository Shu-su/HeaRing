import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:hearing/http/get_historydata.dart';
import 'package:intl/intl.dart';


class HistoryPage extends StatelessWidget {
  final HistoryService historyService = HistoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이전 기록 다시 보기'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: historyService.Alldata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 오류가 발생했을 때 오류 메시지 표시
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('조회된 데이터가 없습니다.'));
          } else {
            final historyData = snapshot.data!;



            return ListView.builder(
              itemCount: historyData.length,
              itemBuilder: (context, index) {
                final history = historyData[index];

                // null-safe 처리
                int historyId = history['historyId'] ?? 0;
                String timestamp = (history['timestamp'] != null && history['timestamp'] != '정보 없음')
                    ? formatTimestamp(history['timestamp'])  // 포맷 적용
                    : '정보 없음';  // 기본값 처리

                String text = history['text'] ?? '내용 없음';
                String location = history['location'] ?? '위치 없음';


                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AudioDialog(historyId: historyId);
                      },
                    );
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: 400,
                      minHeight: 150,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    child: Card(
                      color: const Color(0xFFF8FAE4),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Text(
                                  '${historyData.length - index}', // 역순 번호 (총 길이에서 index를 빼기)
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  '${timestamp?.substring(0, timestamp.length - 5)}', // 첫 번째 부분 (마지막 5글자 제외)
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  '${timestamp?.substring(timestamp.length - 5)}', // 마지막 5글자
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('발화 내용', style: TextStyle(color: Colors.black38, fontSize: 13)),
                                  const SizedBox(height: 5),
                                  Text(
                                    text, // null-safe 적용
                                    style: const TextStyle(color: Colors.black, fontSize: 16),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text('발화 위치', style: TextStyle(color: Colors.black38, fontSize: 13)),
                                  const SizedBox(height: 5),
                                  Text(
                                    location, // null-safe 적용
                                    style: const TextStyle(color: Colors.black, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );

          }
        },
      ),
    );
  }
}


//-------------------------------------------------------------------------



class AudioDialog extends StatefulWidget {
  final int historyId;

  AudioDialog({required this.historyId});

  @override
  _AudioDialogState createState() => _AudioDialogState();
}

class _AudioDialogState extends State<AudioDialog> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late Stream<Duration> _positionStream;
  late Stream<Duration> _durationStream;
  bool _isPlaying = false;
  String? _filePath;
  String? _timestamp;
  String? _location;
  List<String>? _sentences;
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetailData(); // historyId를 기반으로 데이터를 조회
    _positionStream = _audioPlayer.positionStream;
    _durationStream = _audioPlayer.durationStream.map((duration) => duration ??
        Duration.zero);
  }

  Future<void> _fetchDetailData() async {
    try {
      final HistoryService service = HistoryService();
      final data = await service.detaildata(widget.historyId); // historyId로 세부 조회

      print('DDDDDD Received data: $data');  // 전체 응답 출력

      // 상태 업데이트 전에 mounted 체크 추가
      if (mounted) {
        setState(() {
          _filePath = data['filepath'] ?? ''; // 파일 경로
          _timestamp = data['timestamp'] != null ? formatTimestamp(data['timestamp']) : '시간 없음';
          _location = data['location'] ?? '위치 없음';

          _sentences = data['sentences'] is List<dynamic> && data['sentences'].isNotEmpty
              ? data['sentences'][0] is List<dynamic> // 첫 번째 리스트가 실제 리스트라면
              ? List<String>.from(data['sentences'][0].map((item) => item.toString()))
              : [data['sentences'][0].toString()] // 리스트가 아니면 바로 문자열로 처리
              : ['내용 없음'];  // 값이 없으면 '내용 없음'으로 처리

          print('Sentences: $_sentences');

          _loading = false; // 데이터 로드 완료
        });
      }

      if (_filePath != null) {
        try {
          // _filePath 그대로 사용
          await _audioPlayer.setUrl(_filePath!); // URL로 오디오 재생
        } catch (e) {
          if (mounted) {
            setState(() {
              _errorMessage = '오디오 파일 URL 설정 실패';
            });
          }
          print('오디오 재생 오류: $e');
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = '파일 경로가 없습니다. 서버 주소를 확인하세요';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _errorMessage = '상세 데이터 가져오기 실패';
        });
      }
      print('Failed to fetch detail data: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 400,
          minHeight: 300,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 50),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. 재생 아이콘
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: _togglePlayback,
                iconSize: 50, // 아이콘 크기 설정
              ),

              const SizedBox(height: 10),

              // 2. 재생바
              StreamBuilder<Duration>(
                stream: _positionStream,
                builder: (context, positionSnapshot) {
                  final position = positionSnapshot.data ?? Duration.zero;
                  return StreamBuilder<Duration>(
                    stream: _durationStream,
                    builder: (context, durationSnapshot) {
                      final duration = durationSnapshot.data ?? Duration.zero;
                      return ProgressBar(
                        progress: position,
                        total: duration,
                        onSeek: (duration) {
                          _audioPlayer.seek(duration);
                        },
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 10),

              // 3. 발화 내용
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '발화 내용: ',
                    style: TextStyle(color: Colors.black38, fontSize: 13),
                  ),
                  Flexible(
                    child: Text(
                      _sentences != null && _sentences!.isNotEmpty
                          ? _sentences!.join(" ")  // 공백으로 구분하여 결합
                          : '내용 없음',  // 비어있으면 '내용 없음'
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      overflow: TextOverflow.visible,  // 텍스트가 잘리지 않도록 함
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // 4. 발화 위치
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '발화 위치: ',
                    style: TextStyle(color: Colors.black38, fontSize: 13),
                  ),
                  Flexible(
                    child: Text(
                      _location ?? '위치 없음',
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      softWrap: true,  // 자동 줄넘김 활성화
                      overflow: TextOverflow.visible,  // 텍스트가 넘치지 않도록 함
                    ),
                  )
                ],
              ),

              const SizedBox(height: 10),

              // 5. 발화 시간
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '발화 시간: ',
                    style: TextStyle(color: Colors.black38, fontSize: 13),
                  ),
                  Text(
                    _timestamp ?? '시간 없음',
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//timestamp 포멧 코드
String formatTimestamp(String timestamp) {
  try {
    // 'KST', 'AM', 'PM', 'am', 'pm' 모두 제거
    timestamp = timestamp.replaceAll(RegExp(r'KST|am|pm|AM|PM', caseSensitive: false), '').trim();

    // 공백을 하나로 정리
    timestamp = timestamp.replaceAll(RegExp(r'\s+'), ' ');

    print("Cleaned timestamp: $timestamp");  // 디버깅용 출력

    // '2024-11-20 17:56:52' 형식의 타임스탬프를 파싱
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(timestamp);

    // 'yyyy. MM. dd. HH:mm' 형식으로 변환
    return DateFormat("yyyy년 MM월 dd일 HH:mm").format(dateTime);
  } catch (e) {
    print('Error formatting timestamp: $e');
    return '시간 정보 없음';  // 포맷팅 실패 시 기본값 반환
  }
}


import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';



class Recode extends StatefulWidget {
  final String filepath; // filepath를 받아오는 변수 추가

  const Recode({Key? key, required this.filepath}) : super(key: key);

  @override
  State<Recode> createState() => _AudioPlayerWidgetState();
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData({
    required this.position,
    required this.bufferedPosition,
    required this.duration,
  });
}

class _AudioPlayerWidgetState extends State<Recode> {
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _errorMessage; // 오류 메시지를 저장할 변수 추가

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      // filepath를 사용하여 오디오 파일 로드
      await _audioPlayer.setUrl(widget.filepath);
      if (_audioPlayer.duration == null) {
        setState(() {
          _errorMessage = '오디오 파일을 불러오는데 실패했습니다. 파일 경로를 확인해주세요.';
        });
      }
    } catch (e) {
      // 에러 발생 시 에러 메시지 설정
      setState(() {
        _errorMessage = '파일 경로를 로드하는데 실패했습니다: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // positionDataStream 정의
  Stream<PositionData> get positionDataStream => Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
    _audioPlayer.positionStream,
    _audioPlayer.bufferedPositionStream,
    _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
      position: position,
      bufferedPosition: bufferedPosition,
      duration: duration ?? Duration.zero,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFB0B0),
            const Color(0xFFFFFFFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Container(
          width: 350,
          height: 200,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_errorMessage != null)
              // 에러 메시지 표시
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                )
              else ...[
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 48,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                      if (_isPlaying) {
                        _audioPlayer.play();
                      } else {
                        _audioPlayer.pause();
                      }
                    });
                  },
                ),
                StreamBuilder<PositionData>(
                  stream: positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    final progress = positionData?.position ?? Duration.zero;
                    final buffered = positionData?.bufferedPosition ?? Duration.zero;
                    final total = positionData?.duration ?? Duration.zero;
                    return ProgressBar(
                      progress: progress,
                      buffered: buffered,
                      total: total,
                      onSeek: (duration) {
                        _audioPlayer.seek(duration);
                      },
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


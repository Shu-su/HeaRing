import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class DangerPlayPopup extends StatefulWidget {
  final String filepath;

  const DangerPlayPopup({Key? key, required this.filepath}) : super(key: key);

  @override
  _DangerPlayPopupState createState() => _DangerPlayPopupState();
}

class _DangerPlayPopupState extends State<DangerPlayPopup> {
  final player = AudioPlayer();
  late final assetUrl;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    assetUrl = widget.filepath;
    _initPlayer();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('녹음 재생'),
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                _playPauseAudio();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initPlayer() async {
    await player.setAsset(assetUrl);}

  void _playPauseAudio() async {
    if (!_isPlaying) {
      await player.play();
    } else {
      await player.pause();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }
}
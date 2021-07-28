import 'package:flutter/material.dart';

import 'package:assets_audio_player/assets_audio_player.dart';

class HomeScreen extends StatelessWidget {
  AssetsAudioPlayer audioStreamPlayer = AssetsAudioPlayer();
  Future playaudio() async {
    try {
      await audioStreamPlayer.open(
        Audio.liveStream('http://live.mp3quran.net:9718/'),
        showNotification: true,
      );
    } catch (t) {
      print(t);
    }
  }

  pauseaudio() {
    audioStreamPlayer.pause();
  }

  stopaudio() {
    audioStreamPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          MaterialButton(
            onPressed: () {
              playaudio();
            },
            child: Text('play'),
            color: Colors.red,
          ),
          MaterialButton(
            onPressed: () {
              pauseaudio();
            },
            child: Text('pause'),
            color: Colors.red,
          ),
          MaterialButton(
            onPressed: () {
              stopaudio();
            },
            child: Text('stop'),
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

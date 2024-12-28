import 'package:flutter/material.dart';
import 'package:white_noise_backgraund_play_module/viewmodel/background_play_controller.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BackgroundPlayController controller = BackgroundPlayController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('White Noise'),
      ),
      body: Center(
        child: ValueListenableBuilder<bool>(
          valueListenable: controller.isPlaying,
          builder: (context, isPlaying, child) {
            return ElevatedButton(
              onPressed: () {
                if (isPlaying) {
                  controller.pauseBackgroundAudio();
                } else {
                  controller.playBackgroundAudio('assets/cafe-noise-32940.mp3');
                }
                setState(() {
                  controller.isPlaying.value = !isPlaying;
                });
              },
              child: Text(isPlaying ? 'Stop White Noise' : 'Play White Noise'),
            );
          },
        ),
      ),
    );
  }
}

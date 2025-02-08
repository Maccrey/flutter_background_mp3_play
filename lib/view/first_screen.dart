import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_noise_backgraund_play_module/view/whitenoise_player_screen.dart';
import '../model/audio_model.dart';
import '../services/audio_service.dart';

class FirstScreen extends ConsumerWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioList =
        ref.watch(multiAudioViewModelProvider); // Get current playback states

    // Filter the list to get all playing audios
    final playingAudios = audioList
        .where((audio) => audio.playbackState == PlaybackState.playing)
        .toList(); // Get all playing audios

    return Scaffold(
      appBar: AppBar(
          title: const Text('FirstScreen'), automaticallyImplyLeading: false),
      drawer: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Drawer(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Column(
            children: [
              Expanded(
                child: playingAudios.isNotEmpty
                    ? ListView.builder(
                        itemCount: playingAudios.length,
                        itemBuilder: (context, index) {
                          final playingAudio = playingAudios[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(multiAudioViewModelProvider
                                            .notifier)
                                        .togglePlayback(playingAudio.assetPath);
                                  },
                                  child: ClipOval(
                                    child: Image.asset(
                                      playingAudio.imagePath,
                                      width: 60, // 고정된 크기 설정
                                      height: 60, // 고정된 크기 설정
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  playingAudio.name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(child: Text("현재 재생 중인 오디오가 없습니다")),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WhiteNoiseScreen()),
            );
          },
          child: const Text("White Noise"),
        ),
      ),
    );
  }
}

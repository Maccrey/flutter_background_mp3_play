import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/audio_model.dart';
import '../services/audio_service.dart';
import 'whitenoise_player_screen.dart';

class DrewerWhiteNoiseController extends ConsumerWidget {
  const DrewerWhiteNoiseController({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch()를 사용하여 Riverpod provider 접근
    final audioList =
        ref.watch(multiAudioViewModelProvider); // Get current playback states

    // 'playing' 상태의 오디오 필터링
    final playingAudios = audioList
        .where((audio) => audio.playbackState == PlaybackState.playing)
        .toList(); // Get all playing audios

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Drawer(
        backgroundColor: Colors.white,
        width: MediaQuery.of(context).size.width * 0.20,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.15,
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
                    : Center(
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WhiteNoiseScreen())),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                "화이트 노이즈가 재생되고 있지 않습니다".split('').map((char) {
                              return Text(
                                char,
                                style: TextStyle(fontSize: 14),
                              );
                            }).toList(),
                          ),
                        ),
                      )),
            Text(
              'Stop',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

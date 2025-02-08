import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio_service.dart';
import '../model/audio_model.dart';

class WhiteNoiseScreen extends ConsumerWidget {
  const WhiteNoiseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioList = ref.watch(multiAudioViewModelProvider);
    final screenWidth = MediaQuery.of(context).size.width; // 화면 너비

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'White Noise',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.68,
            // color: Colors.red,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (screenWidth ~/ 150)
                    .toInt(), // 150px 간격으로 배치, 화면 너비에 따라 개수 조절
                childAspectRatio: 1.0, // 정사각형 비율
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: audioList.length,
              itemBuilder: (context, index) {
                final audio = audioList[index];
                return _buildSoundControlButton(context, ref, audio);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSoundControlButton(
      BuildContext context, WidgetRef ref, AudioModel audio) {
    return Stack(
      // Stack 위젯으로 변경
      children: [
        // 배경 이미지
        Container(
            width: 200,
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8), // 원하는 둥글기 값 설정
              child: Image.asset(
                audio.imagePath,
                fit: BoxFit.cover, // 이미지 채우기 방식
                height: double.infinity, // Stack에 꽉 채우도록 설정
                width: double.infinity,
              ),
            )),

        // Card 내용 (기존 코드와 거의 동일)
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: Colors.black38, // Card 배경 투명하게 설정
          child: InkWell(
            onTap: () => ref
                .read(multiAudioViewModelProvider.notifier)
                .togglePlayback(audio.assetPath),
            borderRadius:
                BorderRadius.circular(8), // Card의 borderRadius와 동일하게 설정
            child: Padding(
              // Padding 추가
              padding: const EdgeInsets.all(8.0), // 내용에 padding 추가
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getPlaybackIcon(audio.playbackState),
                    size: 60,
                    color: Colors.white, // 아이콘 색상 변경
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 70,
                    child: Text(
                      audio.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // 텍스트 색상 변경
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  StreamBuilder<Duration>(
                    stream: ref
                        .read(multiAudioViewModelProvider.notifier)
                        .getPositionStream(audio.assetPath),
                    builder: (context, snapshot) {
                      final duration = snapshot.data ?? Duration.zero;
                      return Text(
                        '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.white), // 텍스트 색상 변경
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            _buildVolumeDialog(context, ref, audio),
                      );
                    },
                    icon: const Icon(Icons.volume_up,
                        color: Colors.white), // 아이콘 색상 변경
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getPlaybackIcon(PlaybackState state) {
    switch (state) {
      case PlaybackState.stopped:
        return Icons.play_arrow;
      case PlaybackState.playing:
        return Icons.stop;
    }
  }

  Widget _buildVolumeDialog(
      BuildContext context, WidgetRef ref, AudioModel audio) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Volume Control',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Consumer(
              builder: (context, ref, child) {
                final currentVolume = ref.watch(
                    multiAudioViewModelProvider.select((audioList) => audioList
                        .firstWhere(
                            (element) => element.assetPath == audio.assetPath)
                        .volume));
                return Slider(
                  value: currentVolume,
                  onChanged: (value) => ref
                      .read(multiAudioViewModelProvider.notifier)
                      .setVolume(audio.assetPath, value),
                  min: 0,
                  max: 1,
                  divisions: 10,
                  label: currentVolume.toStringAsFixed(1),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Close',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

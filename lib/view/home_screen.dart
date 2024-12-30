import 'package:flutter/material.dart';
import 'package:white_noise_backgraund_play_module/viewmodel/background_play_controller.dart';

// 백그라운드 화이트 노이즈 재생을 위한 홈 화면 위젯
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// 홈 화면의 상태를 관리하는 State 클래스
class _HomeScreenState extends State<HomeScreen> {
  // 백그라운드 오디오 재생을 제어하는 컨트롤러
  final BackgroundPlayController controller = BackgroundPlayController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('White Noise'),
      ),
      body: Center(
        // ValueListenableBuilder를 사용하여 재생 상태 변화 감지
        child: ValueListenableBuilder<bool>(
          valueListenable: controller.isPlaying,
          builder: (context, isPlaying, child) {
            return Column(
              children: [
                // 재생/일시정지 버튼
                ElevatedButton(
                  onPressed: () async {
                    if (isPlaying) {
                      // 현재 재생 중이면 일시정지
                      await controller.pauseBackgroundAudio();
                      controller.isPlaying.value = false;
                    } else {
                      await controller
                          .playBackgroundAudio('assets/cafe-noise-32940.mp3');
                      controller.isPlaying.value = true;
                    }
                  },
                  child: Text(isPlaying ? '일시정지' : '재생'),
                ),
                // 반복 재생 버튼
                ElevatedButton(
                  onPressed: () {
                    if (isPlaying) {
                      controller.pauseBackgroundAudio();
                      controller.isPlaying.value = false;
                    } else {
                      if (controller.currentAssetNotifier.value.isNotEmpty) {
                        controller.resumeBackgroundAudio();
                      } else {
                        controller.playBackgroundLoopAudio(
                            'assets/cafe-noise-32940.mp3');
                      }
                      controller.isPlaying.value = true;
                    }
                  },
                  child: Text(isPlaying ? '일시정지' : '반복재생'),
                ),
                // 정지 버튼
                ElevatedButton(
                  onPressed: () async {
                    await controller.stopBackgroundAudio();
                    await controller.seekTo(Duration.zero);
                    setState(() {
                      controller.isPlaying.value = false;
                      controller.currentAssetNotifier.value = '';
                    });
                  },
                  child: const Text('정지'),
                ),
                // 재개 버튼
                ElevatedButton(
                    onPressed: () {
                      controller.resumeBackgroundAudio();
                    },
                    child: Text('재개')),

                // 재생 중인 오디오 파일 이름 표시
                ValueListenableBuilder<String>(
                  valueListenable: controller.currentAssetNotifier,
                  builder: (context, currentAsset, child) {
                    return Text(currentAsset);
                  },
                ),

                // 오디오 파일 재생 시간을 실시간으로 표시
                StreamBuilder<Duration>(
                  stream: controller.positionStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final duration = snapshot.data!;
                      return Text(
                        '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.titleLarge,
                      );
                    }
                    return const Text('00:00');
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

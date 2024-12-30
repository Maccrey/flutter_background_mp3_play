import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class BackgroundPlayController {
  final AudioPlayer _audioPlayer = AudioPlayer(); // 오디오 플레이어 인스턴스
  final ValueNotifier<bool> isPlaying =
      ValueNotifier<bool>(false); // 재생 상태를 감지하는 ValueNotifier

  // 현재 재생 중인 오디오 파일의 자산 경로를 감시하는 ValueNotifier
  final ValueNotifier<String> currentAssetNotifier =
      ValueNotifier<String>('재생 중인 오디오 없음');
  String? _currentAsset;

  /// 지정된 에셋 경로의 오디오를 백그라운드에서 재생합니다.
  ///
  /// [assetPath]는 재생할 오디오 파일의 에셋 경로입니다.
  ///
  /// 현재 재생 중인 에셋과 다른 경우, 기존 재생을 중지하고 새로운 에셋을 로드합니다.
  /// 루프 모드를 해제하고 오디오를 재생하며, 재생 상태를 true로 설정합니다.
  ///
  /// 에러가 발생하면 콘솔에 에러를 출력하고 예외를 다시 던집니다.
  ///

  /// 재생
  Future<void> playBackgroundAudio(String assetPath) async {
    try {
      if (_currentAsset != assetPath) {
        await _audioPlayer.stop();
        await _audioPlayer.setAsset(assetPath);
        _currentAsset = assetPath;
        currentAssetNotifier.value = assetPath; // 현재 재생 중인 에셋 이름 갱신
      }

      await _audioPlayer.setLoopMode(LoopMode.off);
      await _audioPlayer.play();
      isPlaying.value = true;
    } catch (e) {
      debugPrint('Error playing audio: $e');
      rethrow;
    }
  }

  /// 반복재생
  Future<void> playBackgroundLoopAudio(String assetPath) async {
    try {
      currentAssetNotifier.value = assetPath; // 현재 재생 중인 에셋 이름 갱신
      if (_currentAsset != assetPath) {
        await _audioPlayer.stop();
        await _audioPlayer.setAsset(assetPath);
        await _audioPlayer.setLoopMode(LoopMode.all);
        _currentAsset = assetPath;
      }
      if (_audioPlayer.loopMode != LoopMode.all) {
        await _audioPlayer.setLoopMode(LoopMode.all);
      }
      await _audioPlayer.play();
      isPlaying.value = true;
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  /// 정지
  Future<void> stopBackgroundAudio() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  /// 재개
  resumeBackgroundAudio() {
    try {
      // currentAssetNotifier.value = _currentAsset ??
      //     'resumeBackgroundAudio No audio playing'; // 현재 재생 중인 에셋 이름 갱신
      _audioPlayer.play();
      isPlaying.value = true;
    } catch (e) {
      debugPrint('Error resuming audio: $e');
    }
  }

  /// 일시정지
  pauseBackgroundAudio() {
    try {
      _audioPlayer.pause();
      isPlaying.value = false;
    } catch (e) {
      debugPrint('Error pausing audio: $e');
    }
  }

// 현재 재생 중인 오디오 파일의 재생 시간을 반환합니다.
  currentAsset() {
    return _currentAsset;
  }

// 현재 재생 중인 오디오 파일의 재생 시간을 반환합니다.
  Stream<Duration> positionStream() {
    return _audioPlayer.positionStream;
  }

// 현재 재생 중인 오디오 파일의 재생 시간을 반환합니다.
  seekTo(Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class BackgroundPlayController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);
  String? _currentAsset;

  Future<void> playBackgroundAudio(String assetPath) async {
    try {
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

  Future<void> stopBackgroundAudio() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  void resumeBackgroundAudio() {
    try {
      _audioPlayer.play();
      isPlaying.value = true;
    } catch (e) {
      debugPrint('Error resuming audio: $e');
    }
  }

  void pauseBackgroundAudio() {
    try {
      _audioPlayer.pause();
      isPlaying.value = false;
    } catch (e) {
      debugPrint('Error pausing audio: $e');
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

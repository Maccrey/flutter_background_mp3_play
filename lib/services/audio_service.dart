import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/audio_model.dart';
import '../viewmodel/audio_viewmodel.dart';

class MultiAudioService {
  final Map<String, AudioPlayer> _audioPlayers = {};

  Future<void> play(String assetPath) async {
    if (!_audioPlayers.containsKey(assetPath)) {
      final player = AudioPlayer();
      await player.setAsset(assetPath);
      await player.setLoopMode(LoopMode.all);
      _audioPlayers[assetPath] = player;
    }

    await _audioPlayers[assetPath]!.play();
  }

  Future<void> stop(String assetPath) async {
    await _audioPlayers[assetPath]?.stop();
    await _audioPlayers[assetPath]?.seek(Duration.zero);
  }

  Future<void> setVolume(String assetPath, double volume) async {
    await _audioPlayers[assetPath]?.setVolume(volume);
  }

  Stream<Duration>? positionStream(String assetPath) {
    return _audioPlayers[assetPath]?.positionStream;
  }

  void dispose() {
    _audioPlayers.forEach((_, player) => player.dispose());
    _audioPlayers.clear();
  }
}

final multiAudioViewModelProvider =
    StateNotifierProvider<MultiAudioViewModel, List<AudioModel>>((ref) {
  return MultiAudioViewModel(
    audioService: MultiAudioService(),
    initialSounds: [
      AudioModel(
        name: 'Cafe Noise',
        assetPath: 'lib/core/mp3/cafe-noise-32940.mp3',
      ),
      AudioModel(
        name: 'Rain Noise',
        assetPath: 'lib/core/mp3/sound-of-falling-rain-145473.mp3',
      ),
      AudioModel(
        name: 'Wind Noise',
        assetPath: 'lib/core/mp3/wind__artic__cold-6195.mp3',
      ),
      AudioModel(
        name: 'Fire Noise',
        assetPath: 'lib/core/mp3/fireplace-with-crackling-sounds.mp3',
      ),
    ],
  );
});

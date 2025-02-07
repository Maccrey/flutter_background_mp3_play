class AudioModel {
  final String name;
  final String assetPath;
  final PlaybackState playbackState;
  final double volume;

  AudioModel({
    required this.name,
    required this.assetPath,
    this.playbackState = PlaybackState.stopped,
    this.volume = 0.3,
  });

  AudioModel copyWith({
    String? name,
    String? assetPath,
    PlaybackState? playbackState,
    double? volume,
  }) {
    return AudioModel(
      name: name ?? this.name,
      assetPath: assetPath ?? this.assetPath,
      playbackState: playbackState ?? this.playbackState,
      volume: volume ?? this.volume,
    );
  }
}

enum PlaybackState {
  playing,
  stopped,
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for audio recording and playback.
class AudioState {
  final bool isRecording;
  final bool isPlaying;

  const AudioState({
    this.isRecording = false,
    this.isPlaying = false,
  });

  AudioState copyWith({
    bool? isRecording,
    bool? isPlaying,
  }) {
    return AudioState(
      isRecording: isRecording ?? this.isRecording,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

class AudioNotifier extends StateNotifier<AudioState> {
  AudioNotifier() : super(const AudioState());

  /// Start recording audio from the microphone.
  void startRecording() {
    state = state.copyWith(isRecording: true, isPlaying: false);
  }

  /// Stop recording.
  void stopRecording() {
    state = state.copyWith(isRecording: false);
  }

  /// Start playing audio.
  void startPlaying() {
    state = state.copyWith(isPlaying: true, isRecording: false);
  }

  /// Stop playing audio.
  void stopPlaying() {
    state = state.copyWith(isPlaying: false);
  }
}

/// Provides the current [AudioState].
final audioProvider =
    StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  return AudioNotifier();
});

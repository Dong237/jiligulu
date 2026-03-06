import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the virtual pet 叽叽.
class PetState {
  final int xp;
  final int stage; // 1-6
  final String stageName;

  const PetState({
    this.xp = 0,
    this.stage = 1,
    this.stageName = '蛋蛋',
  });

  PetState copyWith({
    int? xp,
    int? stage,
    String? stageName,
  }) {
    return PetState(
      xp: xp ?? this.xp,
      stage: stage ?? this.stage,
      stageName: stageName ?? this.stageName,
    );
  }
}

class PetNotifier extends StateNotifier<PetState> {
  PetNotifier() : super(const PetState());

  /// Award XP and potentially advance growth stage.
  void addXP(int amount) {
    final newXP = state.xp + amount;
    // Stage thresholds: 0, 100, 300, 600, 1000, 1500
    const thresholds = [0, 100, 300, 600, 1000, 1500];
    const names = ['蛋蛋', '小叽', '叽叽', '大叽', '叽鹉', '金叽'];

    int newStage = state.stage;
    for (int i = thresholds.length - 1; i >= 0; i--) {
      if (newXP >= thresholds[i]) {
        newStage = i + 1;
        break;
      }
    }

    state = state.copyWith(
      xp: newXP,
      stage: newStage,
      stageName: names[newStage - 1],
    );
  }

  /// Reset pet to initial state.
  void reset() {
    state = const PetState();
  }
}

/// Provides the current [PetState].
final petProvider = StateNotifierProvider<PetNotifier, PetState>((ref) {
  return PetNotifier();
});

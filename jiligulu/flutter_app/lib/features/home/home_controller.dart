import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the home page.
class HomeState {
  final int streakDays;
  final int todaySessions;
  final int todayPhrases;
  final int weekSessions;
  final int weekPhrases;

  const HomeState({
    this.streakDays = 0,
    this.todaySessions = 0,
    this.todayPhrases = 0,
    this.weekSessions = 0,
    this.weekPhrases = 0,
  });

  bool get hasHistory =>
      todaySessions > 0 ||
      todayPhrases > 0 ||
      weekSessions > 0 ||
      weekPhrases > 0;

  HomeState copyWith({
    int? streakDays,
    int? todaySessions,
    int? todayPhrases,
    int? weekSessions,
    int? weekPhrases,
  }) {
    return HomeState(
      streakDays: streakDays ?? this.streakDays,
      todaySessions: todaySessions ?? this.todaySessions,
      todayPhrases: todayPhrases ?? this.todayPhrases,
      weekSessions: weekSessions ?? this.weekSessions,
      weekPhrases: weekPhrases ?? this.weekPhrases,
    );
  }
}

/// Controller for home page state.
class HomeController extends StateNotifier<HomeState> {
  HomeController() : super(const HomeState());

  void updateStreak(int days) {
    state = state.copyWith(streakDays: days);
  }

  void updateStats({
    int? todaySessions,
    int? todayPhrases,
    int? weekSessions,
    int? weekPhrases,
  }) {
    state = state.copyWith(
      todaySessions: todaySessions,
      todayPhrases: todayPhrases,
      weekSessions: weekSessions,
      weekPhrases: weekPhrases,
    );
  }
}

final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeState>((ref) {
  return HomeController();
});

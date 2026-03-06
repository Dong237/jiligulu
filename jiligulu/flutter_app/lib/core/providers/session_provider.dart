import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/chat_message.dart';

/// State for an active voice-chat session.
class SessionState {
  final bool isActive;
  final String? currentSessionId;
  final List<ChatMessage> messages;

  const SessionState({
    this.isActive = false,
    this.currentSessionId,
    this.messages = const [],
  });

  SessionState copyWith({
    bool? isActive,
    String? currentSessionId,
    List<ChatMessage>? messages,
  }) {
    return SessionState(
      isActive: isActive ?? this.isActive,
      currentSessionId: currentSessionId ?? this.currentSessionId,
      messages: messages ?? this.messages,
    );
  }
}

class SessionNotifier extends StateNotifier<SessionState> {
  SessionNotifier() : super(const SessionState());

  /// Start a new session.
  void startSession(String sessionId) {
    state = SessionState(
      isActive: true,
      currentSessionId: sessionId,
      messages: [],
    );
  }

  /// Add a message to the current session.
  void addMessage(ChatMessage message) {
    state = state.copyWith(
      messages: [...state.messages, message],
    );
  }

  /// End the current session.
  void endSession() {
    state = state.copyWith(isActive: false);
  }

  /// Clear all session data.
  void clear() {
    state = const SessionState();
  }
}

/// Provides the current [SessionState].
final sessionProvider =
    StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier();
});

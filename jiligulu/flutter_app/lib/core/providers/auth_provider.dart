import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Authentication state for the current user.
class AuthState {
  final bool isAuthenticated;
  final String? userRole; // 'elder' or 'child'
  final String? token;

  const AuthState({
    this.isAuthenticated = false,
    this.userRole,
    this.token,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userRole,
    String? token,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userRole: userRole ?? this.userRole,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  /// Log in with the given token and role.
  void login({required String token, required String role}) {
    state = AuthState(
      isAuthenticated: true,
      userRole: role,
      token: token,
    );
  }

  /// Clear authentication state.
  void logout() {
    state = const AuthState();
  }
}

/// Provides the current [AuthState].
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

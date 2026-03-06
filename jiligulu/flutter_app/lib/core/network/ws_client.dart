import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

// 完整实现在 Phase 2

/// WebSocket client for real-time voice-chat communication.
///
/// Manages connection lifecycle and exposes a message stream.
class WsClient {
  WebSocketChannel? _channel;
  final StreamController<dynamic> _messageController =
      StreamController<dynamic>.broadcast();

  /// Whether the WebSocket is currently connected.
  bool get isConnected => _channel != null;

  /// Stream of incoming messages from the server.
  Stream<dynamic> get messageStream => _messageController.stream;

  /// Connect to the given WebSocket URL.
  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen(
      (data) {
        _messageController.add(data);
      },
      onError: (error) {
        _messageController.addError(error);
      },
      onDone: () {
        _channel = null;
      },
    );
  }

  /// Send data over the WebSocket.
  void send(dynamic data) {
    _channel?.sink.add(data);
  }

  /// Close the WebSocket connection.
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
  }

  /// Dispose resources.
  Future<void> dispose() async {
    await disconnect();
    await _messageController.close();
  }
}

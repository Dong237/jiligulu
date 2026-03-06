/// 对话消息模型
class ChatMessage {
  final String id;
  final String role; // 'user' or 'assistant'
  final String text;
  final DateTime timestamp;
  final List<PhraseData>? phrases;

  ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
    this.phrases,
  });
}

/// 短语数据 — 英文+中文+音标+谐音
class PhraseData {
  final String english;
  final String chinese;
  final String? phoneticIPA;
  final String? phoneticChinese; // 谐音，比如 "How much" → "好嘛吃"
  final String? audioUrl;

  PhraseData({
    required this.english,
    required this.chinese,
    this.phoneticIPA,
    this.phoneticChinese,
    this.audioUrl,
  });
}

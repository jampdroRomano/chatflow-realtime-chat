class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(String id, Map<dynamic, dynamic> map) {
    return ChatMessage(
      id: id,
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? 'Anônimo',
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
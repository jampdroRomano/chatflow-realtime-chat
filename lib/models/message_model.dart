class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime timestamp;
  final String? replyToMessageId;
  final String? replyToSenderName;
  final String? replyToText;
  final bool isDeleted; 

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    this.replyToMessageId,
    this.replyToSenderName,
    this.replyToText,
    this.isDeleted = false, 
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': timestamp.toIso8601String(),
      'replyToMessageId': replyToMessageId,
      'replyToSenderName': replyToSenderName,
      'replyToText': replyToText,
      'isDeleted': isDeleted, 
    };
  }

  factory ChatMessage.fromMap(String id, Map<dynamic, dynamic> map) {
    return ChatMessage(
      id: id,
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? 'Desconhecido',
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      replyToMessageId: map['replyToMessageId'],
      replyToSenderName: map['replyToSenderName'],
      replyToText: map['replyToText'],
      isDeleted: map['isDeleted'] ?? false,
    );
  }
}
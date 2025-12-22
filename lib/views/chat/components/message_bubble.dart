import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final bool showTail;
  final VoidCallback onLongPress;
  final VoidCallback onSwipeReply;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.showTail,
    required this.onLongPress,
    required this.onSwipeReply,
  });

  @override
  Widget build(BuildContext context) {
    final color = isMe ? const Color(0xFF125DFF) : const Color(0xFFF2F2F7);
    final textColor = isMe ? Colors.white : Colors.black;
    final timeColor = isMe ? Colors.white70 : Colors.grey;

    // LÓGICA DE LAYOUT
    final bool isShortMessage = message.text.length < 25 && !message.text.contains('\n');

    return Dismissible(
      key: Key(message.id),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) async {
        onSwipeReply();
        return false;
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.reply, color: Colors.grey),
      ),
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
              top: 2,
              bottom: 2,
              left: isMe ? 64 : 16,
              right: isMe ? 16 : 64,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
                minWidth: 70, 
              ),
              child: IntrinsicWidth(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : (showTail ? 0 : 16)),
                      bottomRight: Radius.circular(isMe ? (showTail ? 0 : 16) : 16),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // RESPOSTA (Se houver)
                      if (message.replyToText != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border(
                              left: BorderSide(
                                color: isMe ? Colors.white : Colors.blue, 
                                width: 4
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.replyToSenderName ?? 'Desconhecido',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: textColor.withValues(alpha: 0.9),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                message.replyToText ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textColor.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // PARTE 2: NOME DO REMETENTE
                      if (!isMe && showTail)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            message.senderName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                              fontSize: 13,
                            ),
                          ),
                        ),

                      // TEXTO E HORÁRIO
                      if (isShortMessage)
                        // LAYOUT INTELIGENTE 
                        Row(
                          mainAxisSize: MainAxisSize.max, 
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                message.text,
                                style: TextStyle(color: textColor, fontSize: 16),
                              ),
                            ),
                            const SizedBox(width: 8), 
                            Text(
                              DateFormat('HH:mm').format(message.timestamp),
                              style: TextStyle(
                                color: timeColor, 
                                fontSize: 11,
                                height: 1.5 
                              ),
                            ),
                          ],
                        )
                      else
                        // LAYOUT PARA MENSAGEM LONGA
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 14), 
                              child: Text(
                                message.text,
                                style: TextStyle(color: textColor, fontSize: 16),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Text(
                                DateFormat('HH:mm').format(message.timestamp),
                                style: TextStyle(color: timeColor, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
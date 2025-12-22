import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final bool showTail;
  final bool isSelected;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final VoidCallback onSwipeReply;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.showTail,
    required this.isSelected,
    required this.onLongPress,
    required this.onTap,
    required this.onSwipeReply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Cores Normais
    final normalColor = isMe ? theme.colorScheme.primary : theme.colorScheme.secondary;
    final bubbleColor = isSelected ? normalColor.withValues(alpha: 0.7) : normalColor;
    // Cor de Fundo da Row (Highlight da seleção)
    final rowColor = isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent;
    final textColor = isMe ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;
    
    final timeColor = isMe 
        ? theme.colorScheme.onPrimary.withValues(alpha: 0.7) 
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);

    // --- MENSAGEM APAGADA ---
    if (message.isDeleted) {
      return Container(
        color: Colors.transparent, 
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.block, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                "Mensagem apagada",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // --- MENSAGEM NORMAL ---
    
    final bool isShortMessage = message.text.length < 25 && !message.text.contains('\n');

    return Container(
      color: rowColor,
      child: Dismissible(
        key: Key(message.id),
        direction: DismissDirection.startToEnd,
        confirmDismiss: (direction) async {
          onSwipeReply();
          return false;
        },
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: Icon(Icons.reply, color: theme.disabledColor),
        ),
        child: GestureDetector(
          onLongPress: onLongPress,
          onTap: onTap,
          child: Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: 2, bottom: 2,
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
                      color: bubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : (showTail ? 0 : 16)),
                        bottomRight: Radius.circular(isMe ? (showTail ? 0 : 16) : 16),
                      ),
                      border: null, 
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // RESPOSTA
                        if (message.replyToText != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border(
                                left: BorderSide(
                                  color: isMe ? Colors.white : theme.primaryColor, 
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

                        // NOME (GRUPOS)
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

                        // TEXTO + HORA
                        if (isShortMessage)
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
      ),
    );
  }
}
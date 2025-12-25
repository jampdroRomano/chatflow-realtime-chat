import 'package:flutter/material.dart';
import '../../../../models/message_model.dart';

class MessageReactionsDisplay extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const MessageReactionsDisplay({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    if (message.reactions.isEmpty) return const SizedBox.shrink();

    // Conta quantas vezes cada reação aparece (ex: 3 👍, 1 ❤️)
    final reactionCounts = <String, int>{};
    
    // Loop corrigido (sem forEach)
    for (final r in message.reactions.values) {
      reactionCounts[r] = (reactionCounts[r] ?? 0) + 1;
    }

    // Pega as top 3 reações para mostrar
    final topReactions = reactionCounts.keys.take(3).toList();
    final totalCount = message.reactions.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...topReactions.map((e) => Text(e, style: const TextStyle(fontSize: 12))),
          if (totalCount > 1) ...[
            const SizedBox(width: 4),
            Text(
              totalCount.toString(),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
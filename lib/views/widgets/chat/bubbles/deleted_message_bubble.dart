import 'package:flutter/material.dart';

class DeletedMessageBubble extends StatelessWidget {
  final bool isMe;

  const DeletedMessageBubble({super.key, required this.isMe});

  @override
  Widget build(BuildContext context) {
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
                fontSize: 14
              ),
            ),
          ],
        ),
      ),
    );
  }
}
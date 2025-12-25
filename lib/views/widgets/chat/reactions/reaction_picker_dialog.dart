import 'package:flutter/material.dart';
import '../../../../core/constants/reaction_constants.dart';

class ReactionPickerDialog extends StatelessWidget {
  final VoidCallback onDismiss;
  final Function(String) onReactionSelected;
  final Offset tapPosition; 

  const ReactionPickerDialog({
    super.key,
    required this.onDismiss,
    required this.onReactionSelected,
    required this.tapPosition,
  });

  @override
  Widget build(BuildContext context) {
    // Calcula posição para ficar acima do dedo
    final double leftPos = (tapPosition.dx - 150).clamp(10.0, MediaQuery.of(context).size.width - 310);
    final double topPos = tapPosition.dy - 70;

    return Stack(
      children: [
        // Fundo transparente que fecha o menu ao tocar fora
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.transparent),
          ),
        ),
        // O Card com os emojis
        Positioned(
          top: topPos,
          left: leftPos,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: ReactionConstants.availableReactions.map((emoji) {
                  return GestureDetector(
                    onTap: () => onReactionSelected(emoji),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
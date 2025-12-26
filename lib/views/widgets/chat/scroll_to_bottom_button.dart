import 'package:flutter/material.dart';

class ScrollToBottomButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ScrollToBottomButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      elevation: 6.0,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_downward,
            size: 24,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}

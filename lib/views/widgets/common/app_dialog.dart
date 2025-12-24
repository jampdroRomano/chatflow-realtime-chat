import 'package:flutter/material.dart';

enum DialogType { success, error, info, warning }

class AppDialog extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? child;
  final DialogType type;
  final String mainButtonText;
  final VoidCallback? onMainAction;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryAction;

  const AppDialog({
    super.key,
    required this.title,
    this.description,
    this.child,
    this.type = DialogType.info,
    this.mainButtonText = "OK",
    this.onMainAction,
    this.secondaryButtonText,
    this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Color headerColor;
    IconData icon;

    switch (type) {
      case DialogType.success:
        headerColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case DialogType.error:
        headerColor = theme.colorScheme.error;
        icon = Icons.error;
        break;
      case DialogType.warning:
        headerColor = Colors.orange;
        icon = Icons.warning;
        break;
      case DialogType.info:
        headerColor = theme.colorScheme.primary;
        icon = Icons.info;
        break;
    }

    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: headerColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: headerColor, size: 48),
            ),
            const SizedBox(height: 16),
          
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          if (description != null)
            Text(
              description!,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              textAlign: TextAlign.center,
            ),

          if (child != null) ...[
            const SizedBox(height: 16),
            child!,
          ],

          const SizedBox(height: 24),
          
          Row(
            children: [
              if (secondaryButtonText != null) ...[
                Expanded(
                  child: TextButton(
                    onPressed: onSecondaryAction ?? () => Navigator.of(context).pop(),
                    child: Text(
                      secondaryButtonText!,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],

              Expanded(
                child: ElevatedButton(
                  onPressed: onMainAction ?? () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: headerColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: Text(
                    mainButtonText,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
  }
}
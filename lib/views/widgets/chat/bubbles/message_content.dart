import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/message_model.dart';

class MessageContent extends StatelessWidget {
  final ChatMessage message;
  final Color textColor;
  final Color timeColor;
  final bool isShortMessage;

  const MessageContent({
    super.key,
    required this.message,
    required this.textColor,
    required this.timeColor,
    required this.isShortMessage,
  });

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('HH:mm').format(message.timestamp);

    if (isShortMessage) {
      return Row(
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
            timeString,
            style: TextStyle(
              color: timeColor,
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      );
    }

    return Stack(
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
            timeString,
            style: TextStyle(color: timeColor, fontSize: 11),
          ),
        ),
      ],
    );
  }
}
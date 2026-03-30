import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Widget? icon;
  final bool iconLeft;
  const Button({
    super.key,
    required this.text,
    this.icon,
    this.iconLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 189, 49, 214),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null && iconLeft) ...[
            icon!,
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          if (icon != null && !iconLeft) ...[
            const SizedBox(width: 8),
            icon!,
          ],
        ],
      ),
    );
  }
}
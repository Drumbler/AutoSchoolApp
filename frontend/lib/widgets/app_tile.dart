import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  final Color color;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final double height;

  const AppTile({
    required this.color,
    required this.title,
    required this.onTap,
    required this.height,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: height,
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: Colors.black87),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black87),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

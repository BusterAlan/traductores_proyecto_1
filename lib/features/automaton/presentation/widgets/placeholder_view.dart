import "package:flutter/material.dart";

/// Placeholder view to represent the empty state of the main Cubit load
class PlaceholderView extends StatelessWidget {
  /// Placeholder view to represent the empty state of the main Cubit load
  const PlaceholderView({required this.icon, required this.message, super.key});

  /// Icon data value
  final IconData icon;

  /// Message string value
  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}

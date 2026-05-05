import "package:flutter/material.dart";

/// Error view to shown if in the load of Cubit has any
/// error to display to the final user
class ErrorView extends StatelessWidget {
  /// Error view to shown if in the load of Cubit has any
  /// error to display to the final user
  const ErrorView({required this.failure, super.key});

  /// Failure value
  final String failure;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                failure,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}

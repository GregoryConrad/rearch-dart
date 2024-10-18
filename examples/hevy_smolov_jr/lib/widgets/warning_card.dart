import 'package:flutter/material.dart';

/// Displays a warning in a [Card].
class WarningCard extends StatelessWidget {
  /// Displays a warning in a [Card].
  const WarningCard({
    required this.title,
    required this.details,
    this.onPressed,
    super.key,
  });

  /// The title of the warning.
  final String title;

  /// The details of the warning.
  final String details;

  /// What to do when the [WarningCard] is pressed.
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.warning),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(title, style: textTheme.titleMedium),
                  Text(details),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

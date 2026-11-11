import 'package:flutter/material.dart';

/// Shows the question number, icon and text in a themed card.
class QuestionCard extends StatelessWidget {
  final int number;
  final int total;
  final String question;
  final IconData icon;

  const QuestionCard({
    super.key,
    required this.number,
    required this.total,
    required this.question,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: scheme.primaryContainer,
              child: Icon(icon, size: 34, color: scheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Question $number of $total',
              style: textTheme.titleMedium?.copyWith(color: scheme.primary),
            ),
            const SizedBox(height: 8),
            Text(
              question,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}

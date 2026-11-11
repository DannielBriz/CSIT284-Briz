import 'package:flutter/material.dart';

import '../models/wellness_question.dart';

/// Displays score, classification, dynamic message and recommendation.
class ResultView extends StatelessWidget {
  final int score;
  final int maxScore;

  const ResultView({super.key, required this.score, required this.maxScore});

  @override
  Widget build(BuildContext context) {
    final result = WellnessResult.fromScore(score, maxScore);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(result.icon, size: 72, color: result.color),
        const SizedBox(height: 12),
        Text(
          result.headline,
          textAlign: TextAlign.center,
          style: textTheme.headlineSmall?.copyWith(color: result.color),
        ),
        const SizedBox(height: 20),
        Text('Your Wellness Score', style: textTheme.titleMedium),
        Text(
          '$score / $maxScore',
          style: textTheme.headlineLarge?.copyWith(color: result.color),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: maxScore == 0 ? 0 : score / maxScore,
            color: result.color,
            backgroundColor: result.color.withOpacity(0.15),
          ),
        ),
        const SizedBox(height: 20),
        Text.rich(
          TextSpan(children: [
            const TextSpan(
                text: 'Classification: ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: result.classification),
          ]),
          style: textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(children: [
            const TextSpan(
                text: 'Recommendation: ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: result.recommendation),
          ]),
          style: textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

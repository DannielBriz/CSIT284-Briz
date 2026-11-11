import 'package:flutter/material.dart';

/// One selectable answer and the points it is worth.
class AnswerOption {
  final String text;
  final int score;

  const AnswerOption({required this.text, required this.score});
}

/// A single wellness question with its answer choices (3-5).
class WellnessQuestion {
  final String text;
  final IconData icon;
  final List<AnswerOption> options;

  const WellnessQuestion({
    required this.text,
    required this.icon,
    required this.options,
  });
}

/// Classification + feedback derived from the total score.
class WellnessResult {
  final String classification;
  final String headline;
  final String recommendation;
  final IconData icon;
  final Color color;

  const WellnessResult({
    required this.classification,
    required this.headline,
    required this.recommendation,
    required this.icon,
    required this.color,
  });

  /// Uses percentage of the max score so it still works if questions change.
  factory WellnessResult.fromScore(int score, int maxScore) {
    final pct = maxScore == 0 ? 0 : score / maxScore;

    if (pct >= 0.75) {
      return const WellnessResult(
        classification: 'Healthy Balance',
        headline: 'Excellent Wellness Habits',
        recommendation:
            'Keep maintaining your current habits. You are balancing study and self-care well!',
        icon: Icons.sentiment_very_satisfied,
        color: Color(0xFF2E9E5B),
      );
    } else if (pct >= 0.5) {
      return const WellnessResult(
        classification: 'Moderate Balance',
        headline: 'Moderate Wellness Habits',
        recommendation:
            'You are doing okay, but try improving sleep, hydration, or taking regular study breaks.',
        icon: Icons.sentiment_neutral,
        color: Color(0xFFE8A317),
      );
    } else {
      return const WellnessResult(
        classification: 'At Risk',
        headline: 'Needs Improvement',
        recommendation:
            'Your habits need attention. Prioritize rest, healthy meals, movement, and talk to someone you trust.',
        icon: Icons.sentiment_dissatisfied,
        color: Color(0xFFD9534F),
      );
    }
  }
}

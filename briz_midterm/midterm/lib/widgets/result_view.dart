import 'package:flutter/material.dart';

class ResultView extends StatelessWidget {
  final int score;
  final int maxScore;

  const ResultView({
    super.key,
    required this.score,
    required this.maxScore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safeMaxScore = maxScore > 0 ? maxScore : 1;
    final percentage = (score / safeMaxScore).clamp(0.0, 1.0);
    final percentValue = (percentage * 100).round();

    final String classification;
    final String recommendation;
    final IconData resultIcon;
    final Color resultColor;

    if (percentage >= 0.75) {
      classification = 'Doing Well';
      recommendation =
          'You are building positive wellness habits. Keep making '
          'time for rest, movement, balanced meals, and supportive '
          'relationships. Small consistent habits can make a difference.';
      resultIcon = Icons.sentiment_very_satisfied_rounded;
      resultColor = Colors.green;
    } else if (percentage >= 0.45) {
      classification = 'Finding Your Balance';
      recommendation =
          'You have some positive habits to build on. Try choosing '
          'one area to improve this week, such as getting more sleep, '
          'taking short movement breaks, or planning time to unwind.';
      resultIcon = Icons.sentiment_satisfied_alt_rounded;
      resultColor = Colors.orange;
    } else {
      classification = 'Time to Recharge';
      recommendation =
          'It may help to start with small, manageable changes. '
          'Prioritize rest, regular meals, gentle activity, and '
          'connecting with someone you trust. Reach out to campus '
          'support services if you need extra help.';
      resultIcon = Icons.favorite_border_rounded;
      resultColor = Colors.deepOrange;
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'YOUR WELLNESS SCORE',
              style: theme.textTheme.labelLarge?.copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$score',
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 6,
                              bottom: 10,
                            ),
                            child: Text(
                              '/ $maxScore',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$percentValue% of maximum score',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Icon(
                  resultIcon,
                  size: 58,
                  color: resultColor,
                ),
              ],
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 12,
                backgroundColor:
                    theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(resultColor),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: resultColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    resultIcon,
                    color: resultColor,
                    size: 30,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classification,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: resultColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          recommendation,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Wellness is a journey, not a competition. '
                    'Focus on progress rather than perfection.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
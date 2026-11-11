import 'package:flutter/material.dart';

import '../widgets/result_view.dart';
import 'assessment_screen.dart';
import 'home_screen.dart';

class ResultsScreen extends StatelessWidget {
  final int score;
  final int maxScore;

  const ResultsScreen({
    super.key,
    required this.score,
    required this.maxScore,
  });

  void restartAssessment(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const AssessmentScreen(),
      ),
    );
  }

  void goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.sizeOf(context).width >= 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Wellness Results'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.celebration_rounded,
                    size: 42,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Assessment Complete!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You took an important step by checking in '
                    'with your wellbeing.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _illustration(theme),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: ResultView(
                            score: score,
                            maxScore: maxScore,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    _illustration(theme),
                    const SizedBox(height: 20),
                    ResultView(
                      score: score,
                      maxScore: maxScore,
                    ),
                  ],
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    onPressed: () => restartAssessment(context),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Restart Assessment'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => goHome(context),
                    icon: const Icon(Icons.home_rounded),
                    label: const Text('Back to Home'),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Remember: this assessment is for general '
                    'wellness awareness and is not a medical diagnosis.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _illustration(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Image.asset(
        'assets/images/undraw_fitness_stats.png',
        height: 220,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.insights_rounded,
            size: 140,
            color: theme.colorScheme.primary,
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../widgets/result_view.dart';
import 'assessment_screen.dart';
import 'home_screen.dart';

class ResultsScreen extends StatelessWidget {
  final int score;
  final int maxScore;

  const ResultsScreen({super.key, required this.score, required this.maxScore});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final illustration = Image.asset(
      'lib/assets/images/undraw_fitness_stats.png',
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.insights, size: 120, color: scheme.primary),
    );

    final details = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ResultView(score: score, maxScore: maxScore),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AssessmentScreen()),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Restart Assessment'),
            ),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (_) => false,
              ),
              icon: const Icon(Icons.home),
              label: const Text('Home'),
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Results'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700 ||
                MediaQuery.of(context).orientation == Orientation.landscape;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: SizedBox(height: 260, child: illustration)),
                            const SizedBox(width: 24),
                            Expanded(child: details),
                          ],
                        )
                      : details,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

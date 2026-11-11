import 'package:flutter/material.dart';

import 'assessment_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // TODO: replace with your own details
  static const String studentName = 'John Doe';
  static const String studentProgram = 'BSCS-3';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final illustration = Image.asset(
      'lib/assets/images/undraw_meditation.png',
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.self_improvement, size: 140, color: scheme.primary),
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Campus Wellness Tracker',
          textAlign: TextAlign.center,
          style: textTheme.headlineLarge?.copyWith(color: scheme.primary),
        ),
        const SizedBox(height: 8),
        Text(
          'Evaluate your current study-life balance.',
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: scheme.primaryContainer,
              child: Icon(Icons.person, color: scheme.primary),
            ),
            title: const Text(studentName,
                style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text(studentProgram),
          ),
        ),
        const SizedBox(height: 28),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AssessmentScreen()),
          ),
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start Assessment'),
        ),
      ],
    );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700 ||
                MediaQuery.of(context).orientation == Orientation.landscape;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: SizedBox(height: 280, child: illustration)),
                            const SizedBox(width: 32),
                            Expanded(child: content),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 220, child: illustration),
                            const SizedBox(height: 24),
                            content,
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../data/wellness_questions.dart';
import '../widgets/answer_button.dart';
import '../widgets/question_card.dart';
import 'results_screen.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  // Selected option index per question (null = not answered yet).
  final List<int?> _selected =
      List<int?>.filled(wellnessQuestions.length, null);

  int _currentIndex = 0;
  bool _isAdvancing = false;

  /// Running score: sum of the scores of all selected answers.
  int get _totalScore {
    var total = 0;
    for (var i = 0; i < _selected.length; i++) {
      final choice = _selected[i];
      if (choice != null) total += wellnessQuestions[i].scores[choice];
    }
    return total;
  }

  int get _maxScore => wellnessQuestions.fold(
        0,
        (sum, q) => sum + q.scores.reduce((a, b) => a > b ? a : b),
      );

  Future<void> _selectAnswer(int optionIndex) async {
    if (_isAdvancing) return;

    setState(() {
      _selected[_currentIndex] = optionIndex;
      _isAdvancing = true;
    });

    // Brief pause so the user sees their selection highlighted.
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    if (_currentIndex == wellnessQuestions.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultsScreen(
            score: _totalScore,
            maxScore: _maxScore,
          ),
        ),
      );
    } else {
      setState(() {
        _currentIndex++;
        _isAdvancing = false;
      });
    }
  }

  void _previousQuestion() {
    if (_isAdvancing || _currentIndex == 0) return;
    setState(() => _currentIndex--);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = wellnessQuestions[_currentIndex];

    final questionCard = QuestionCard(
      question: question.question,
      questionNumber: _currentIndex + 1,
      totalQuestions: wellnessQuestions.length,
    );

    final answers = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < question.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AnswerButton(
              letter: String.fromCharCode(65 + i),
              label: question.options[i],
              isSelected: _selected[_currentIndex] == i,
              onPressed: () => _selectAnswer(i),
            ),
          ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Wellness Check'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Chip(
              avatar: Icon(
                Icons.bolt_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              label: Text('Score: $_totalScore'),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 32 : 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: KeyedSubtree(
                          key: ValueKey(_currentIndex),
                          child: isWide
                              // Tablet / landscape: question beside answers
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: questionCard),
                                    const SizedBox(width: 24),
                                    Expanded(child: answers),
                                  ],
                                )
                              // Phone portrait: stacked
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    questionCard,
                                    const SizedBox(height: 20),
                                    answers,
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed:
                              _currentIndex == 0 ? null : _previousQuestion,
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: const Text('Previous question'),
                        ),
                      ),
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
import 'package:flutter/material.dart';

import '../data/wellness_question.dart';
import '../widgets/answer_button.dart';
import '../widgets/question_card.dart';
import 'results_screen.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  int _currentIndex = 0;
  int _totalScore = 0;
  int? _selectedIndex;
  bool _locked = false; // prevents double taps while transitioning

  int get _maxScore => wellnessQuestions.fold(
      0,
      (sum, q) =>
          sum + q.options.map((o) => o.score).reduce((a, b) => a > b ? a : b));

  Future<void> _selectAnswer(int optionIndex) async {
    if (_locked) return;

    final question = wellnessQuestions[_currentIndex];
    setState(() {
      _locked = true;
      _selectedIndex = optionIndex;
      _totalScore += question.options[optionIndex].score; // record the score
    });

    // brief pause so the user sees their selection highlighted
    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    if (_currentIndex < wellnessQuestions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
        _locked = false;
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              ResultsScreen(score: _totalScore, maxScore: _maxScore),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = wellnessQuestions[_currentIndex];
    final total = wellnessQuestions.length;

    final questionCard = QuestionCard(
      number: _currentIndex + 1,
      total: total,
      question: question.text,
      icon: question.icon,
    );

    final answers = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < question.options.length; i++)
          AnswerButton(
            text: question.options[i].text,
            selected: _selectedIndex == i,
            onTap: _locked ? null : () => _selectAnswer(i),
          ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Wellness Assessment')),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // progress info
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (_currentIndex + 1) / total,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Question ${_currentIndex + 1} of $total',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: KeyedSubtree(
                          key: ValueKey(_currentIndex),
                          child: isWide
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(child: questionCard),
                                    const SizedBox(width: 24),
                                    Expanded(child: answers),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    questionCard,
                                    const SizedBox(height: 16),
                                    answers,
                                  ],
                                ),
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

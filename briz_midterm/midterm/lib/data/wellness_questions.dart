import '../models/wellness_question.dart';

const List<WellnessQuestion> wellnessQuestions = [
  WellnessQuestion(
    question: 'How many hours do you typically sleep each night?',
    options: [
      'Less than 4 hours',
      '4–6 hours',
      '7–8 hours',
      'More than 8 hours',
    ],
    scores: [0, 1, 3, 2],
  ),
  WellnessQuestion(
    question: 'How often do you engage in physical activity?',
    options: [
      'Rarely or never',
      '1–2 days a week',
      '3–5 days a week',
      'Almost every day',
    ],
    scores: [0, 1, 2, 3],
  ),
  WellnessQuestion(
    question: 'How would you describe your current stress level?',
    options: [
      'Overwhelmed most days',
      'Stressed quite often',
      'Manageable',
      'Generally calm',
    ],
    scores: [0, 1, 2, 3],
  ),
  WellnessQuestion(
    question: 'How often do you eat balanced meals?',
    options: [
      'Almost never',
      'Some days',
      'Most days',
      'Every day',
    ],
    scores: [0, 1, 2, 3],
  ),
  WellnessQuestion(
    question: 'How connected do you feel to friends and classmates?',
    options: [
      'Very isolated',
      'A little connected',
      'Fairly connected',
      'Well supported',
    ],
    scores: [0, 1, 2, 3],
  ),
  WellnessQuestion(
    question: 'How well do you balance study and personal time?',
    options: [
      'No balance at all',
      'Often out of balance',
      'Usually balanced',
      'Consistently balanced',
    ],
    scores: [0, 1, 2, 3],
  ),
];
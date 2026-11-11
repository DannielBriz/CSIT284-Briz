import 'package:flutter/material.dart';

import '../models/wellness_question.dart';

/// Higher score = healthier habit.
const List<WellnessQuestion> wellnessQuestions = [
  WellnessQuestion(
    text: 'How many hours do you typically sleep?',
    icon: Icons.bedtime,
    options: [
      AnswerOption(text: 'Less than 4 hours', score: 1),
      AnswerOption(text: '4-6 hours', score: 2),
      AnswerOption(text: '7-8 hours', score: 4),
      AnswerOption(text: 'More than 8 hours', score: 3),
    ],
  ),
  WellnessQuestion(
    text: 'How many glasses of water do you drink per day?',
    icon: Icons.water_drop,
    options: [
      AnswerOption(text: '0-2 glasses', score: 1),
      AnswerOption(text: '3-5 glasses', score: 2),
      AnswerOption(text: '6-8 glasses', score: 4),
    ],
  ),
  WellnessQuestion(
    text: 'How often do you exercise or move around each week?',
    icon: Icons.directions_run,
    options: [
      AnswerOption(text: 'Never', score: 1),
      AnswerOption(text: '1-2 times', score: 2),
      AnswerOption(text: '3-4 times', score: 3),
      AnswerOption(text: '5 or more times', score: 4),
    ],
  ),
  WellnessQuestion(
    text: 'How would you rate your stress level today?',
    icon: Icons.psychology,
    options: [
      AnswerOption(text: 'Very high', score: 1),
      AnswerOption(text: 'High', score: 2),
      AnswerOption(text: 'Manageable', score: 3),
      AnswerOption(text: 'Low', score: 4),
    ],
  ),
  WellnessQuestion(
    text: 'How consistently do you take breaks while studying?',
    icon: Icons.menu_book,
    options: [
      AnswerOption(text: 'I study for hours without stopping', score: 1),
      AnswerOption(text: 'Sometimes', score: 2),
      AnswerOption(text: 'Usually', score: 3),
      AnswerOption(text: 'Always, I follow a schedule', score: 4),
    ],
  ),
  WellnessQuestion(
    text: 'How many regular meals do you eat per day?',
    icon: Icons.restaurant,
    options: [
      AnswerOption(text: '1 meal or fewer', score: 1),
      AnswerOption(text: '2 meals', score: 2),
      AnswerOption(text: '3 meals', score: 4),
    ],
  ),
];

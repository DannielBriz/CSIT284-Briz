import 'package:flutter/material.dart';
import 'package:expense_tracker/models/category.dart' as category_model;
import 'package:expense_tracker/models/expense.dart' as expense_model;

// Categories for the Topic 8 navigation lesson.
const availableCategories = [
  category_model.Category(id: 'c1', title: 'Food', color: Colors.orange),
  category_model.Category(id: 'c2', title: 'Travel', color: Colors.blue),
  category_model.Category(id: 'c3', title: 'Leisure', color: Colors.purple),
  category_model.Category(id: 'c4', title: 'Work', color: Colors.green),
];

// Sample expenses for the Expense Tracker.
final List<expense_model.Expense> dummyExpenses = [
  expense_model.Expense(
    title: 'Groceries',
    amount: 45.50,
    date: DateTime(2026, 10, 15),
    category: expense_model.Category.food,
  ),
  expense_model.Expense(
    title: 'Bus fare',
    amount: 3.50,
    date: DateTime(2026, 10, 16),
    category: expense_model.Category.travel,
  ),
  expense_model.Expense(
    title: 'Movie ticket',
    amount: 15.69,
    date: DateTime(2026, 10, 17),
    category: expense_model.Category.leisure,
  ),
  expense_model.Expense(
    title: 'School supplies',
    amount: 12.75,
    date: DateTime(2026, 10, 18),
    category: expense_model.Category.work,
  ),
];

import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, required this.title, required this.expenses});

  final String title;
  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: expenses.isEmpty
          ? const Center(child: Text('No expenses found.'))
          : ExpensesList(expenses: expenses, onRemoveExpense: (_) {}),
    );
  }
}

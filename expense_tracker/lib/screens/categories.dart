import 'package:flutter/material.dart';
import 'package:expense_tracker/data/dummy_data.dart';
import 'package:expense_tracker/models/category.dart' as category_model;
import 'package:expense_tracker/models/expense.dart' as expense_model;
import 'package:expense_tracker/screens/meals.dart';
import 'package:expense_tracker/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void _selectCategory(BuildContext context, category_model.Category category) {
    final selectedCategory = switch (category.id) {
      'c1' => expense_model.Category.food,
      'c2' => expense_model.Category.travel,
      'c3' => expense_model.Category.leisure,
      'c4' => expense_model.Category.work,
      _ => null,
    };

    if (selectedCategory == null) return;

    final filteredExpenses = dummyExpenses
        .where((expense) => expense.category == selectedCategory)
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) =>
            MealsScreen(title: category.title, expenses: filteredExpenses),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick your category')),
      body: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            ),
        ],
      ),
    );
  }
}

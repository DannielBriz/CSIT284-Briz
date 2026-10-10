import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

const List<String> categories = [
  'Food',
  'Transportation',
  'School',
  'Bills',
  'Other',
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F8F5),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFFF5F8F5),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> expenses = [];

  bool isLoading = true;
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  List<Map<String, dynamic>> get filteredExpenses {
    if (selectedFilter == 'All') {
      return expenses;
    }

    return expenses.where((expense) {
      return (expense['category'] as String? ?? 'Other') == selectedFilter;
    }).toList();
  }

  Future<void> loadExpenses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('expenses');

      if (savedData != null) {
        final List<dynamic> decoded = jsonDecode(savedData);

        if (!mounted) return;

        setState(() {
          expenses.addAll(
            decoded.map((item) => Map<String, dynamic>.from(item as Map)),
          );
        });
      }
    } catch (e) {
      debugPrint('Error loading expenses: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> saveExpenses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('expenses', jsonEncode(expenses));
    } catch (e) {
      debugPrint('Error saving expenses: $e');
    }
  }

  double get totalExpenses {
    return expenses.fold<double>(
      0,
      (total, expense) => total + (expense['amount'] as num).toDouble(),
    );
  }

  double categoryTotal(String category) {
    return expenses.fold<double>(0, (total, expense) {
      if ((expense['category'] as String? ?? 'Other') == category) {
        return total + (expense['amount'] as num).toDouble();
      }
      return total;
    });
  }

  IconData categoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Transportation':
        return Icons.directions_bus;
      case 'School':
        return Icons.school;
      case 'Bills':
        return Icons.receipt_long;
      default:
        return Icons.shopping_bag;
    }
  }

  Color categoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.orange;
      case 'Transportation':
        return Colors.blue;
      case 'School':
        return Colors.purple;
      case 'Bills':
        return Colors.red;
      default:
        return Colors.teal;
    }
  }

  Future<void> showAddExpenseDialog() async {
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    String selectedCategory = 'Food';

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('Add Expense'),
                content: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Expense name',
                            hintText: 'e.g. Lunch',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter an expense name.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Amount (₱)',
                            hintText: 'e.g. 150.00',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            final amount = double.tryParse(value?.trim() ?? '');

                            if (amount == null ||
                                !amount.isFinite ||
                                amount <= 0) {
                              return 'Enter a valid positive amount.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() {
                                selectedCategory = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      final description = descriptionController.text.trim();
                      final amount = double.parse(amountController.text.trim());

                      setState(() {
                        expenses.add({
                          'description': description,
                          'amount': amount,
                          'category': selectedCategory,
                        });
                      });

                      await saveExpenses();

                      if (!mounted) return;

                      Navigator.pop(dialogContext);

                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(
                          content: Text('Added $description successfully!'),
                        ),
                      );
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      descriptionController.dispose();
      amountController.dispose();
    }
  }

  Future<void> deleteExpense(int index) async {
    final deletedExpense = Map<String, dynamic>.from(expenses[index]);

    setState(() {
      expenses.removeAt(index);
    });

    await saveExpenses();

    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${deletedExpense['description']} deleted.'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () async {
              if (!mounted) return;

              setState(() {
                expenses.insert(
                  index.clamp(0, expenses.length),
                  deletedExpense,
                );
              });

              await saveExpenses();
            },
          ),
        ),
      );
  }

  Widget buildCategorySummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spending by Category',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'See where your money goes.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            ...categories.map((category) {
              final amount = categoryTotal(category);
              final percentage = totalExpenses == 0
                  ? 0.0
                  : amount / totalExpenses;
              final color = categoryColor(category);

              return Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: color.withOpacity(0.12),
                          child: Icon(
                            categoryIcon(category),
                            color: color,
                            size: 19,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            category,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          '₱${amount.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: percentage,
                      minHeight: 7,
                      color: color,
                      backgroundColor: color.withOpacity(0.12),
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${(percentage * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildExpenseList() {
    final visibleExpenses = filteredExpenses;

    if (visibleExpenses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.receipt_long, size: 50, color: Colors.grey),
              const SizedBox(height: 10),
              Text(
                selectedFilter == 'All'
                    ? 'No expenses yet'
                    : 'No $selectedFilter expenses',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                selectedFilter == 'All'
                    ? 'Tap Add Expense to get started.'
                    : 'Try another category or add an expense.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: visibleExpenses.map((expense) {
        final category = expense['category'] as String? ?? 'Other';
        final amount = (expense['amount'] as num).toDouble();
        final originalIndex = expenses.indexOf(expense);

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: categoryColor(category).withOpacity(0.12),
              child: Icon(
                categoryIcon(category),
                color: categoryColor(category),
              ),
            ),
            title: Text(expense['description'] as String),
            subtitle: Text(category),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '₱${amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  tooltip: 'Delete expense',
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => deleteExpense(originalIndex),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Overview',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      color: Colors.green.shade700,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.account_balance_wallet,
                              size: 42,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Expenses',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₱${totalExpenses.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${expenses.length} expense${expenses.length == 1 ? '' : 's'} recorded',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildCategorySummary(),
                    const SizedBox(height: 20),
                    const Text(
                      'Recent Expenses',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedFilter,
                      decoration: const InputDecoration(
                        labelText: 'Filter by category',
                        prefixIcon: Icon(Icons.filter_list),
                        border: OutlineInputBorder(),
                      ),
                      items: ['All', ...categories].map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedFilter = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    buildExpenseList(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isLoading ? null : showAddExpenseDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }
}

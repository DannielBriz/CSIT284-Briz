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

const List<String> sortOptions = [
  'Newest first',
  'Highest amount',
  'Lowest amount',
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
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
  String selectedSort = 'Newest first';

  List<Map<String, dynamic>> get filteredExpenses {
    if (selectedFilter == 'All') {
      return expenses;
    }

    return expenses
        .where((expense) => expense['category'] == selectedFilter)
        .toList();
  }

  List<Map<String, dynamic>> get displayedExpenses {
    final result = filteredExpenses.toList();

    switch (selectedSort) {
      case 'Highest amount':
        result.sort(
          (a, b) => (b['amount'] as num).compareTo(a['amount'] as num),
        );
        break;

      case 'Lowest amount':
        result.sort(
          (a, b) => (a['amount'] as num).compareTo(b['amount'] as num),
        );
        break;

      case 'Newest first':
      default:
        result.sort(
          (a, b) => expenses.indexOf(b).compareTo(expenses.indexOf(a)),
        );
        break;
    }

    return result;
  }

  double get totalExpenses {
    return expenses.fold<double>(
      0,
      (total, expense) => total + (expense['amount'] as num).toDouble(),
    );
  }

  double categoryTotal(String category) {
    return expenses
        .where((expense) => expense['category'] == category)
        .fold<double>(
          0,
          (total, expense) => total + (expense['amount'] as num).toDouble(),
        );
  }

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedExpenses = prefs.getString('expenses');

      if (savedExpenses != null) {
        final decoded = jsonDecode(savedExpenses) as List;

        expenses.addAll(
          decoded.map((item) => Map<String, dynamic>.from(item as Map)),
        );
      }
    } catch (error) {
      debugPrint('Error loading expenses: $error');
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('expenses', jsonEncode(expenses));
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
        return Colors.green;
    }
  }

  Future<void> showAddExpenseDialog() async {
    final formKey = GlobalKey<FormState>();
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();

    String selectedCategory = categories.first;

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('Add Expense'),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            hintText: 'e.g. Lunch',
                            prefixIcon: Icon(Icons.edit),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a description';
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
                            prefixIcon: Icon(Icons.payments),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            final amount = double.tryParse(value?.trim() ?? '');

                            if (amount == null || amount <= 0) {
                              return 'Enter an amount greater than zero';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            prefixIcon: Icon(Icons.category),
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

                      final newExpense = <String, dynamic>{
                        'description': descriptionController.text.trim(),
                        'amount': double.parse(amountController.text.trim()),
                        'category': selectedCategory,
                      };

                      setState(() {
                        expenses.add(newExpense);
                      });

                      Navigator.pop(dialogContext);

                      try {
                        await saveExpenses();
                      } catch (error) {
                        debugPrint('Error saving expense: $error');
                      }

                      if (mounted) {
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text('Expense added successfully!'),
                          ),
                        );
                      }
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

  Future<void> deleteExpense(Map<String, dynamic> expense) async {
    final originalIndex = expenses.indexOf(expense);

    if (originalIndex == -1) {
      return;
    }

    setState(() {
      expenses.removeAt(originalIndex);
    });

    try {
      await saveExpenses();
    } catch (error) {
      debugPrint('Error saving deleted expense: $error');
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${expense['description']} deleted'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () async {
              setState(() {
                final insertIndex = originalIndex > expenses.length
                    ? expenses.length
                    : originalIndex;

                expenses.insert(insertIndex, expense);
              });

              try {
                await saveExpenses();
              } catch (error) {
                debugPrint('Error restoring expense: $error');
              }
            },
          ),
        ),
      );
  }

  Widget buildTotalCard() {
    return Card(
      elevation: 0,
      color: Colors.green.shade700,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.account_balance_wallet, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Total Expenses',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '₱${totalExpenses.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${expenses.length} ${expenses.length == 1 ? 'expense' : 'expenses'} recorded',
              style: TextStyle(color: Colors.white.withOpacity(0.85)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategorySummary() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spending by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...categories.map((category) {
              final amount = categoryTotal(category);
              final percentage = totalExpenses == 0
                  ? 0.0
                  : amount / totalExpenses;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          categoryIcon(category),
                          color: categoryColor(category),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(category)),
                        Text(
                          '₱${amount.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: percentage,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      color: categoryColor(category),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 3),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${(percentage * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
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
    final visibleExpenses = displayedExpenses;

    if (visibleExpenses.isEmpty) {
      return Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.receipt_long, size: 44, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(
                  selectedFilter == 'All'
                      ? 'No expenses yet'
                      : 'No $selectedFilter expenses found',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedFilter == 'All'
                      ? 'Tap Add Expense to get started.'
                      : 'Try another category or add an expense.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: visibleExpenses.map((expense) {
        final category = expense['category'] as String;
        final amount = (expense['amount'] as num).toDouble();

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            leading: CircleAvatar(
              backgroundColor: categoryColor(category).withOpacity(0.12),
              child: Icon(
                categoryIcon(category),
                color: categoryColor(category),
              ),
            ),
            title: Text(
              expense['description'] as String,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(category),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '₱${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: 'Expense options',
                  onSelected: (value) {
                    if (value == 'delete') {
                      deleteExpense(expense);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
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
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  buildTotalCard(),
                  const SizedBox(height: 20),
                  buildCategorySummary(),
                  const SizedBox(height: 24),
                  const Text(
                    'Recent Expenses',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedFilter,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Category',
                      prefixIcon: Icon(Icons.filter_list),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
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
                  DropdownButtonFormField<String>(
                    value: selectedSort,
                    decoration: const InputDecoration(
                      labelText: 'Sort Expenses',
                      prefixIcon: Icon(Icons.sort),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: sortOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedSort = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  buildExpenseList(),
                ],
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

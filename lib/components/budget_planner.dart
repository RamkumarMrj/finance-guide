import 'package:flutter/material.dart';

class Budget {
  final String category;
  double limit;
  double spent;

  Budget({required this.category, required this.limit, this.spent = 0.0});
}

List<Budget> budgets = [
  Budget(category: 'Food', limit: 200.0),
  Budget(category: 'Entertainment', limit: 100.0),
  // Add more sample budgets here
];

class BudgetPlannerPage extends StatefulWidget {
  const BudgetPlannerPage({Key? key}) : super(key: key);

  @override
  State<BudgetPlannerPage> createState() => _BudgetPlannerPageState();
}

class _BudgetPlannerPageState extends State<BudgetPlannerPage> {
  void _editBudget(int index, double newLimit) {
    setState(() {
      budgets[index].limit = newLimit;
    });
  }

  void _addExpense(int index, double amount) {
    setState(() {
      budgets[index].spent += amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: budgets.length,
              itemBuilder: (context, index) {
                final budget = budgets[index];
                final remaining = budget.limit - budget.spent;
                return ListTile(
                  title: Text(budget.category),
                  subtitle:
                      Text('Remaining: \$${remaining.toStringAsFixed(2)}'),
                  trailing: Text('\$${budget.spent.toStringAsFixed(2)} spent'),
                  onTap: () {
                    _openAddExpenseDialog(context, index);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddBudgetDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openEditBudgetDialog(BuildContext context, int index) async {
    double newLimit = budgets[index].limit;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Budget'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Limit'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  newLimit = double.tryParse(value) ?? newLimit;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _editBudget(index, newLimit);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _openAddBudgetDialog(BuildContext context) async {
    String category = '';
    double limit = 0.0;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Budget'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (value) {
                  category = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Limit'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  limit = double.tryParse(value) ?? 0.0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (category.isNotEmpty && limit > 0) {
                  setState(() {
                    budgets.add(Budget(category: category, limit: limit));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _openAddExpenseDialog(BuildContext context, int index) async {
    double amount = 0.0;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  double parsedValue = double.tryParse(value) ?? 0.0;
                  setState(() {
                    amount = parsedValue;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (amount > 0) {
                  _addExpense(index, amount);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(home: BudgetPlannerPage()));
}

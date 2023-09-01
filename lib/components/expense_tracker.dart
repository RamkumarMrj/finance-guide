// expense_tracker.dart

import 'package:flutter/material.dart';

class Expense {
  final String title;
  final String category;
  final double amount;

  Expense({required this.title, required this.category, required this.amount});
}

List<Expense> expenses = [
  Expense(title: 'Groceries', category: 'Food', amount: 50.0),
  Expense(title: 'Movie Tickets', category: 'Entertainment', amount: 20.0),
  // Add more sample expenses here
];

class ExpenseTrackerPage extends StatefulWidget {
  const ExpenseTrackerPage({super.key});

  @override
  State<ExpenseTrackerPage> createState() => _ExpenseTrackerPageState();
}

class _ExpenseTrackerPageState extends State<ExpenseTrackerPage> {

  void _deleteExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
  }

  List<Expense> expenses = []; // Maintain a list of expenses

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ListTile(
                  title: Text(expense.title),
                  subtitle: Text(expense.category),
                  trailing: Text('₹ ${expense.amount.toStringAsFixed(2)}'),
                  // Add the three-dot menu for delete action
                  onTap: () {
                    _openPopupMenu(context, index);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddExpenseDialog(context); // Open dialog to add new expense
        },
        child: const Icon(Icons.add),
      ),
    );
  }

   // Function to open the three-dot menu
  void _openPopupMenu(BuildContext context, int index) async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0), // Adjust the position
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete'),
            onTap: () {
              Navigator.of(context).pop(); // Close the menu
              _deleteExpense(index); // Delete the expense
            },
          ),
        ),
      ],
    );
  }

  void _openAddExpenseDialog(BuildContext context) async {
    Expense newExpense = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddExpenseDialog(); // Custom dialog to input new expense details
      },
    );

    setState(() {
      expenses.add(newExpense); // Add new expense to the list
    });
  }
}

class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog({super.key});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  String _title = '';
  String _category = '';
  double _amount = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Expense'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Title'),
            onChanged: (value) {
              setState(() {
                _title = value;
              });
            },
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Category'),
            onChanged: (value) {
              setState(() {
                _category = value;
              });
            },
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              setState(() {
                _amount = double.tryParse(value) ?? 0.0;
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
            if (_title.isNotEmpty && _category.isNotEmpty && _amount > 0) {
              Navigator.of(context).pop(
                Expense(title: _title, category: _category, amount: _amount),
              );
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(home: ExpenseTrackerPage()));
}

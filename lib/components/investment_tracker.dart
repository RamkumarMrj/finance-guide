// investment_tracker.dart

import 'package:flutter/material.dart';

class Investment {
  final String name;
  final double initialAmount;
  final double currentValue;

  Investment({
    required this.name,
    required this.initialAmount,
    required this.currentValue,
  });
}

List<Investment> investments = [
  Investment(name: 'Stocks', initialAmount: 5000.0, currentValue: 5500.0),
  Investment(name: 'Bonds', initialAmount: 10000.0, currentValue: 9800.0),
  // Add more sample investments here
];

class InvestmentTrackerPage extends StatelessWidget {
  const InvestmentTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: investments.length,
        itemBuilder: (context, index) {
          final investment = investments[index];
          final growthPercentage =
              ((investment.currentValue - investment.initialAmount) /
                      investment.initialAmount) *
                  100;
          return ListTile(
            title: Text(investment.name),
            subtitle: Text('Initial: \$${investment.initialAmount.toStringAsFixed(2)} | Current: \$${investment.currentValue.toStringAsFixed(2)}'),
            trailing: Text('${growthPercentage.toStringAsFixed(2)}%'),
          );
        },
      ),
    );
  }
}

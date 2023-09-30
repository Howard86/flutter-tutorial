import 'dart:math';
import 'package:firstapp/expense_app/models/expense.dart';
import 'package:firstapp/expense_app/widgets/chart_bar.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({
    super.key,
    required this.expenses,
  });

  final List<Expense> expenses;

  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(expenses, Category.food),
      ExpenseBucket.forCategory(expenses, Category.leisure),
      ExpenseBucket.forCategory(expenses, Category.travel),
      ExpenseBucket.forCategory(expenses, Category.work),
    ];
  }

  double get maxTotalExpense {
    return buckets.fold(
      0,
      (previousValue, bucket) => max(previousValue, bucket.totalExpenses),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(.3),
            Theme.of(context).colorScheme.primary.withOpacity(0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
      ),
      child: Column(
        children: [
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final bucket in buckets)
                ChartBar(
                  fill: maxTotalExpense > 0
                      ? bucket.totalExpenses / maxTotalExpense
                      : 0,
                ),
            ],
          )),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final bucket in buckets)
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        categoryIcons[bucket.category],
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.7),
                      )),
                ),
            ],
          )
        ],
      ),
    );
  }
}

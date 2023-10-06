import 'package:firstapp/quiz_app/summary_item.dart';
import 'package:firstapp/quiz_app/results_screen.dart';
import 'package:flutter/material.dart';

class QuestionSummary extends StatelessWidget {
  const QuestionSummary({
    super.key,
    required this.summary,
  });

  final List<SummaryData> summary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        child: Column(children: [
          for (final data in summary) SummaryItem(data: data),
        ]),
      ),
    );
  }
}

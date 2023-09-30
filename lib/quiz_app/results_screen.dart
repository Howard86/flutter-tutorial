import 'package:firstapp/quiz_app/data/questions.dart';
import 'package:firstapp/quiz_app/question_summary.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef SummaryData = ({
  int index,
  String question,
  String correctAnswer,
  String chosenAnswer,
});

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.chosenAnswers,
    required this.onStart,
  });

  final List<String> chosenAnswers;
  final void Function() onStart;

  List<SummaryData> get summaryData {
    final List<SummaryData> summaries = [];

    for (var i = 0; i < chosenAnswers.length; i++) {
      summaries.add((
        index: i,
        question: questions[i].text,
        correctAnswer: questions[i].answers[0],
        chosenAnswer: chosenAnswers[i]
      ));
    }

    return summaries;
  }

  @override
  Widget build(BuildContext context) {
    final correctQuestionsCount = summaryData
        .where((data) => data.chosenAnswer == data.correctAnswer)
        .length;

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You answered $correctQuestionsCount out of ${questions.length} questions correctly!',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            QuestionSummary(summary: summaryData),
            const SizedBox(
              height: 30,
            ),
            TextButton.icon(
              onPressed: onStart,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Restart Quiz'),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:firstapp/quiz_app/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryItem extends StatelessWidget {
  const SummaryItem({
    super.key,
    required this.data,
  });

  final SummaryData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: data.chosenAnswer == data.correctAnswer
                ? Colors.blue
                : Colors.pink,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            '${data.index + 1}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                data.question,
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                data.correctAnswer,
                style: const TextStyle(
                  color: Colors.blue,
                ),
              ),
              Text(
                data.chosenAnswer,
                style: const TextStyle(color: Colors.pink),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

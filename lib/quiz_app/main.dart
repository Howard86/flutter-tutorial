import 'package:firstapp/quiz_app/data/questions.dart';
import 'package:firstapp/quiz_app/question_screen.dart';
import 'package:firstapp/quiz_app/results_screen.dart';
import 'package:firstapp/quiz_app/start_screen.dart';
import 'package:flutter/material.dart';

enum Screens { start, question, result }

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  final List<String> _selectedAnswers = [];
  Screens _activeScreen = Screens.start;

  void chooseAnswer(String answer) {
    _selectedAnswers.add(answer);

    if (_selectedAnswers.length == questions.length) {
      setState(
        () => _activeScreen = Screens.result,
      );
    }
  }

  void startQuiz() => setState(
        () {
          _activeScreen = Screens.question;
          _selectedAnswers.clear();
        },
      );

  @override
  Widget build(BuildContext context) {
    Widget screen = switch (_activeScreen) {
      Screens.start => StartScreen(
          onStart: startQuiz,
        ),
      Screens.question => QuestionScreen(
          onSelectAnswer: chooseAnswer,
        ),
      Screens.result => ResultsScreen(
          chosenAnswers: _selectedAnswers,
          onStart: startQuiz,
        )
    };

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple,
                Colors.purple,
              ],
            ),
          ),
          child: screen,
        ),
      ),
    );
  }
}

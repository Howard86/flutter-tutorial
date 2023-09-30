class QuizQuestion {
  const QuizQuestion({required this.text, required this.answers});

  final String text;
  final List<String> answers;

  List<String> get shuffledAnswers {
    final shuffled = List.of(answers);
    shuffled.shuffle();
    return shuffled;
  }
}

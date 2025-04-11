class QuizQuestions {
  const QuizQuestions(this.text, this.answers, this.difficulty);

  final String text;
  final List<String> answers;
  final String difficulty;
  List<String> getShuffledAnswers() {
    final shuffledList = List.of(answers);
    shuffledList.shuffle();
    return shuffledList;
  }
}

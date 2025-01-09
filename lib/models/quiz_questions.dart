class QuizQuestions {
  const QuizQuestions(this.text, this.answers);
  
  final String text;
  final List<String> answers;

  List<String> getShuffledAnswers() {
    final shuffledList = List.of(answers); // creates copy of the string
    shuffledList.shuffle(); // shuffles the list
    return shuffledList;
  }

}
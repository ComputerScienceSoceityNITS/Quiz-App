import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/models/quiz_questions.dart';
import 'package:quiz_app/questions_screen.dart';
import 'package:quiz_app/results_screen.dart';
import 'package:quiz_app/start_screen.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});
  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  List<String> selectedAnswers = [];
  List<String> selectedDifficulties = [];
  List<QuizQuestions> filteredQuestions = [];

  var activeScreen = 'start-screen';

  // Track start times and total durations per question
  Map<int, Duration> questionTimes = {};
  DateTime? questionStartTime;
  int currentQuestionIndex = 0;

  void switchScreen(List<String> difficulties) {
    setState(() {
      selectedDifficulties = difficulties;
      filteredQuestions = questions
          .where((q) => selectedDifficulties.contains(q.difficulty))
          .toList();
      selectedAnswers = [];
      questionTimes.clear();
      currentQuestionIndex = 0;
      activeScreen = 'questions-screen';
      questionStartTime = DateTime.now();
    });
  }

  void chooseAnswer(String answer) {
    final now = DateTime.now();
    final timeSpent = now.difference(questionStartTime!);

    // Update time spent on current question
    questionTimes[currentQuestionIndex] =
        (questionTimes[currentQuestionIndex] ?? Duration.zero) + timeSpent;

    selectedAnswers.add(answer);
    if (selectedAnswers.length == filteredQuestions.length) {
      setState(() {
        activeScreen = 'results-screen';
      });
    } else {
      setState(() {
        currentQuestionIndex++;
        questionStartTime = DateTime.now();
      });
    }
  }

  void unchooseAnswer() {
    final now = DateTime.now();
    final timeSpent = now.difference(questionStartTime!);

    questionTimes[currentQuestionIndex] =
        (questionTimes[currentQuestionIndex] ?? Duration.zero) + timeSpent;

    selectedAnswers.removeLast();
    setState(() {
      currentQuestionIndex--;
      questionStartTime = DateTime.now();
    });
  }

  void restartQuiz() {
    setState(() {
      selectedAnswers = [];
      activeScreen = 'start-screen';
      currentQuestionIndex = 0;
      questionTimes.clear();
    });
  }

  @override
  Widget build(context) {
    Widget screenWidget = StartScreen(switchScreen);

    if (activeScreen == 'questions-screen') {
      screenWidget = QuestionsScreen(
        onSelectAnswer: chooseAnswer,
        onBack: unchooseAnswer,
        chosenAnswers: selectedAnswers,
        questions: filteredQuestions,
      );
    }

    if (activeScreen == 'results-screen') {
      screenWidget = ResultsScreen(
        chosenAnswers: selectedAnswers,
        onRestart: restartQuiz,
        questionTimes: questionTimes,
        filteredQuestions: filteredQuestions,
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 48, 12, 110),
                Color.fromARGB(255, 99, 37, 206),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/models/quiz_questions.dart';
import 'package:quiz_app/questions_screen.dart';
import 'package:quiz_app/results_screen.dart';
import 'package:quiz_app/start_screen.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  List<String> selectedAnswers = [];
  List<String> selectedDifficulties = [];
  List<QuizQuestions> filteredQuestions = [];

  var activeScreen = 'start-screen';

  void switchScreen(List<String> difficulties) {
    final matchedQuestions = questions.where((q) {
      return difficulties.contains(q.difficulty);
    }).toList();

    if (matchedQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('No questions available for the selected difficulties.'),
        ),
      );
      return;
    }

    setState(() {
      selectedDifficulties = difficulties;
      filteredQuestions = matchedQuestions;
      activeScreen = 'questions-screen';
    });
  }

  void chooseAnswer(String answer) {
    selectedAnswers.add(answer);

    if (selectedAnswers.length == filteredQuestions.length) {
      setState(() {
        activeScreen = 'results-screen';
      });
    }
  }

  void unchooseAnswer() {
    if (selectedAnswers.isNotEmpty) {
      selectedAnswers.removeLast();
    }
  }

  void restartQuiz() {
    setState(() {
      selectedAnswers = [];
      selectedDifficulties = [];
      filteredQuestions = [];
      activeScreen = 'start-screen';
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
        questions:
            filteredQuestions, // 👈 this should match what you used in QuestionsScreen
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

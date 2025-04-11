import 'package:flutter/material.dart';
import 'package:quiz_app/answer_button.dart';
import 'package:quiz_app/models/quiz_questions.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({
    super.key,
    required this.onSelectAnswer,
    required this.onBack,
    required this.chosenAnswers,
    required this.questions,
  });

  final void Function(String answer) onSelectAnswer;
  final void Function() onBack;
  final List<String> chosenAnswers;
  final List<QuizQuestions> questions;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  var currentQuestionIndex = 0;

  @override
  Widget build(context) {
    final currentQuestion = widget.questions[currentQuestionIndex];

    List<Map<String, Object>> getSummaryData() {
      final List<Map<String, Object>> summary = [];

      for (var i = 0; i < widget.chosenAnswers.length; i++) {
        summary.add(
          {
            'question_index': i,
            'question': widget.questions[i].text,
            'answer': widget.questions[i].answers[0],
            'user_answer': widget.chosenAnswers[i],
          },
        );
      }
      return summary;
    }

    final summaryData = getSummaryData();
    final numTotalQs = widget.questions.length;
    final numCorrectQs = summaryData.where((data) {
      return data['answer'] == data['user_answer'];
    }).length;

    void answerQuestion(String selectedAnswer) {
      widget.onSelectAnswer(selectedAnswer);
      setState(() {
        currentQuestionIndex += 1;
      });
    }

    void unanswerQuestion() {
      widget.onBack();
      setState(() {
        currentQuestionIndex -= 1;
      });
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'Score: ${numCorrectQs}${currentQuestionIndex > 0 ? ' / $currentQuestionIndex' : ''}',
            style: GoogleFonts.lato(
              color: const Color.fromARGB(255, 223, 189, 237),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                currentQuestion.text,
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ...currentQuestion.getShuffledAnswers().map((item) {
                return AnswerButton(
                  ansText: item,
                  onTap: () {
                    answerQuestion(item);
                  },
                );
              }),
            ],
          ),
        ),
        Column(
          children: [
            const Spacer(),
            if (currentQuestionIndex > 0)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: OutlinedButton.icon(
                  onPressed: unanswerQuestion,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(
                    Icons.arrow_circle_left_outlined,
                    color: Colors.white,
                  ),
                  label: const Text('Previous Question'),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

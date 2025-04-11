import 'package:flutter/material.dart';
import 'package:quiz_app/answer_button.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen(
      {super.key, required this.onSelectAnswer, required this.onBack});

  final void Function(String answer) onSelectAnswer;
  final void Function() onBack;

  @override
  State<QuestionsScreen> createState() {
    return _QuestionsScreenState();
  }
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  var currentQuestionIndex = 0;

  @override
  Widget build(context) {
    final currentQuestion = questions[currentQuestionIndex];

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
            Spacer(),
            (currentQuestionIndex > 0)
                ? Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        unanswerQuestion();
                      },
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
                  )
                : SizedBox(),
          ],
        )
      ],
    );
  }
}

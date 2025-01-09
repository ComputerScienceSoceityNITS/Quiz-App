import 'package:flutter/material.dart';
import 'package:quiz_app/answer_button.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key, required this.onSelectAnswer});

  final void Function(String answer) onSelectAnswer;

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

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Container(
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

            // list.map -> applies the function to every element in the list nd returns a new list with the transformed elements
            // Note: this does not change the original list

            // Spreading values (...) - pulls all the values inside the list nd places them as comma seperated values

            ...currentQuestion.getShuffledAnswers().map((item) {
              return AnswerButton(
                ansText: item,
                onTap: () {
                  answerQuestion(item); // if passing function as a callback (nd not immediately calling it) -> pass pointer to it
                  // in this case too function not passed immediately. The anonymous function is forwarded to onTap;
                  // this function will be executed only when the anonymous function is trigerred inside the button
                }, 
              );
            })
            // AnswerButton(
            //   ansText: currentQuestion.answers[0],
            //   onTap: () {},
            // ),
          ],
        ),
      ),
    );
  }
}

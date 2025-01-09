import 'package:flutter/material.dart';

class QuestionsSummary extends StatelessWidget {
  const QuestionsSummary({super.key, required this.summaryData});

  final List<Map<String, Object>> summaryData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // fixes the height of the SizedBox
      child: SingleChildScrollView(
        // makes the contents scrollable (if exceeding height)
        child: Column(
          children: summaryData.map((data) {
            final userAns = data['user_answer'] as String;
            final correctAns = data['answer'] as String;
            final questionIndex = (data['question_index'] as int) + 1;
            final containerColor = userAns == correctAns
                ? const Color.fromARGB(255, 62, 145, 213)
                : const Color.fromARGB(255, 202, 62, 188);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: containerColor,
                    child: Text(
                      questionIndex.toString(),
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['question'] as String,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        Text(
                          'Your answer: $userAns',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 200, 119, 214),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        Text(
                          'Correct answer: $correctAns',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 132, 160, 211),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

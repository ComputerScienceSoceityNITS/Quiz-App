import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/models/quiz_questions.dart';
import 'package:quiz_app/questions_summary.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.chosenAnswers,
    required this.onRestart,
    required this.questionTimes,
    required this.filteredQuestions,
  });

  final void Function() onRestart;
  final List<String> chosenAnswers;
  final Map<int, Duration> questionTimes;
  final List<QuizQuestions> filteredQuestions;

  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < chosenAnswers.length; i++) {
      summary.add({
        'question_index': i,
        'question': filteredQuestions[i].text,
        'answer': filteredQuestions[i].answers[0],
        'user_answer': chosenAnswers[i],
      });
    }

    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final summaryData = getSummaryData();
    final numTotalQs = filteredQuestions.length;
    final numCorrectQs = summaryData.where((data) {
      return data['answer'] == data['user_answer'];
    }).length;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You answered $numCorrectQs out of $numTotalQs questions correctly!',
              style: GoogleFonts.lato(
                color: const Color.fromARGB(255, 223, 189, 237),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(child: QuestionsSummary(summaryData: summaryData)),
            const SizedBox(height: 30),
            Text(
              'Time Spent per Question (seconds)',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                        reservedSize: 30,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) => Text(
                          'Q${value.toInt() + 1}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  barGroups: questionTimes.entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.inSeconds.toDouble(),
                          width: 16,
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextButton.icon(
              onPressed: onRestart,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                iconColor: Colors.white,
              ),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Home', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}

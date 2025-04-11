import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatefulWidget {
  const StartScreen(this.startQuiz, {super.key});

  final void Function(List<String> selectedDifficulties) startQuiz;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final List<String> difficulties = ['Easy', 'Medium', 'Hard'];
  final List<String> selectedDifficulties = [];

  void toggleDifficulty(String difficulty) {
    setState(() {
      if (selectedDifficulties.contains(difficulty)) {
        selectedDifficulties.remove(difficulty);
      } else {
        selectedDifficulties.add(difficulty);
      }
    });
  }

  void _showDifficultyDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 48, 12, 110),
          title: const Text(
            'Select Difficulty',
            style: TextStyle(color: Colors.white),
          ),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: difficulties.map((difficulty) {
                  final isSelected = selectedDifficulties.contains(difficulty);
                  return CheckboxListTile(
                    title: Text(difficulty,
                        style: const TextStyle(color: Colors.white)),
                    value: isSelected,
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    onChanged: (_) {
                      setState(() {
                        // also update in parent state
                        toggleDifficulty(difficulty);
                      });
                      setStateDialog(() {});
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Done', style: TextStyle(color: Colors.white)),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayText = selectedDifficulties.isEmpty
        ? 'Select Difficulty'
        : selectedDifficulties.join(', ');

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/quiz-logo.png',
            width: 300,
            color: const Color.fromARGB(167, 255, 255, 255),
          ),
          const SizedBox(height: 80),
          Text(
            'Learn Flutter the fun way!',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: _showDifficultyDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayText,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (selectedDifficulties.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select at least one difficulty.'),
                  ),
                );
                return;
              }
              widget.startQuiz(selectedDifficulties);
            },
            child: const Text('Start Quiz'),
          ),
        ],
      ),
    );
  }
}

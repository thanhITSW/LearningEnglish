import 'package:flutter/material.dart';

class TypingPracticeScreen extends StatelessWidget {
  final int numberOfQuestions;
  final bool englishToVietnamese;
  final bool autoPronounce;
  final bool shuffleQuestions;

  const TypingPracticeScreen({
    Key? key,
    required this.numberOfQuestions,
    required this.englishToVietnamese,
    required this.autoPronounce,
    required this.shuffleQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Typing Practice'),
      ),
      body: Center(
        child:
            Text('Typing Practice Feature with $numberOfQuestions questions'),
      ),
    );
  }
}

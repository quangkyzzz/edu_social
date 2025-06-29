import 'package:flutter/material.dart';
import 'package:quick_quiz/quick_quiz.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Quick Quiz Example'),
        ),
        body: Builder(
          builder: (context) => Center(
            child: TextButton(
              child: const Text(
                "Play Quiz",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuizScreen extends StatelessWidget {
  final quiz = Quiz(
    questions: [
      QuestionModel(
        question:
            'How is acceleration related to mass and force according to Newton\'s second law of motion?',
        options: [
          'Acceleration is directly proportional to mass and inversely proportional to force',
          'Acceleration is directly proportional to force and mass',
          'Acceleration is inversely proportional to mass and force',
          'Acceleration is inversely proportional to force and directly proportional to mass'
        ],
        correctAnswerIndex: 0,
      ),
      QuestionModel(
        question: 'What is the largest planet in our solar system?',
        options: ['Earth', 'Jupiter', 'Mars', 'Saturn'],
        correctAnswerIndex: 1,
      ),
      QuestionModel(
        question: 'Which animal is known as the "King of the Jungle"?',
        options: ['Tiger', 'Lion', 'Elephant', 'Bear'],
        correctAnswerIndex: 1,
      ),
    ],
    timerDuration: 30,
  );

  QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
        ),
        body: QuizPage(quiz: quiz));
  }
}

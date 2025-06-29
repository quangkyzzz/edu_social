import 'package:quick_quiz/quick_quiz.dart';
import 'package:social_app/common/common.dart';
import 'package:social_app/features/home/test_detail.dart';
import 'package:social_app/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestView extends ConsumerStatefulWidget {
  const TestView({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const TestView(),
      );

  @override
  ConsumerState<TestView> createState() => _TestViewState();
}

class _TestViewState extends ConsumerState<TestView> {
  final quiz = Quiz(
    questions: [
      QuestionModel(
        question: 'How is acceleration related to mass and force according to Newton\'s second law of motion?',
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIConstants.appBar(),
      body: QuizPage(quiz: quiz),
    );
  }
}

class NewWidget extends StatelessWidget {
  final String avatar;
  final String name;
  final String text1;
  final String text2;
  const NewWidget({
    super.key,
    required this.avatar,
    required this.name,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, TestDetailView.route());
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(avatar),
        radius: 30,
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            text1,
            style: const TextStyle(
              color: Pallete.whiteColor,
              fontSize: 16,
            ),
          ),
          Text(
            text2,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

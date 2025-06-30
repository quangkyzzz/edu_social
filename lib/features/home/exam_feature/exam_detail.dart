// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:quick_quiz/quick_quiz.dart';

import 'package:social_app/common/common.dart';

class ExamDetail extends StatefulWidget {
  final Quiz quiz;
  static route(Quiz quiz) => MaterialPageRoute(
        builder: (context) => ExamDetail(quiz: quiz),
      );
  const ExamDetail({
    super.key,
    required this.quiz,
  });

  @override
  State<ExamDetail> createState() => _ExamDetailState();
}

class _ExamDetailState extends State<ExamDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIConstants.appBar(),
      body: QuizPage(quiz: widget.quiz),
    );
  }
}

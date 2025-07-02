// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_quiz/quick_quiz.dart';
import 'package:social_app/apis/exam_api.dart';

import 'package:social_app/common/common.dart';
import 'package:social_app/models/exam_model.dart';
import 'package:social_app/provider/get_exam_provider.dart';

class ExamDetail extends StatefulWidget {
  final Quiz quiz;
  final ExamModel exam;
  final String userID;
  static route(Quiz quiz, ExamModel exam, String userID) => MaterialPageRoute(
        builder: (context) => ExamDetail(
          quiz: quiz,
          exam: exam,
          userID: userID,
        ),
      );
  const ExamDetail({
    super.key,
    required this.quiz,
    required this.exam,
    required this.userID,
  });

  @override
  State<ExamDetail> createState() => _ExamDetailState();
}

class _ExamDetailState extends State<ExamDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIConstants.appBar(),
      body: QuizPage(
        quiz: widget.quiz,
        onFinish: (List<int> listans, int durationTake) {
          print('qqq list and: $listans');
          ExamApi().updateExamHistory(
            createAt: widget.exam.createAt,
            listAns: listans,
            userID: widget.userID,
            durationTake: durationTake,
            oldHistory: widget.exam.historys,
          );
        },
      ),
    );
  }
}

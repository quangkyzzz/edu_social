import 'package:flutter/material.dart';
import 'package:social_app/apis/exam_api.dart';
import 'package:social_app/models/exam_model.dart';

class GetExamProvider extends ChangeNotifier {
  List<ExamModel> exams = [];
  bool isLoading = false;
  Future<void> getExam() async {
    isLoading = true;
    notifyListeners();
    exams = await ExamApi().getExam();
    isLoading = false;
    notifyListeners();
  }
}

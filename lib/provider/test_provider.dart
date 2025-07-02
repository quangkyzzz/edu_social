import 'package:flutter/material.dart';
import 'package:quick_quiz/quick_quiz.dart';
import 'package:social_app/apis/exam_api.dart';
import 'package:social_app/models/exam_model.dart';

class TestProvider extends ChangeNotifier {
  List<ExamModel> exams = [];
  Quiz? answer;
  bool isLoading = false;
  Future<void> getExam() async {
    isLoading = true;
    notifyListeners();
    exams = await ExamApi().getExam();
    isLoading = false;
    notifyListeners();
  }

  void setAnswer({required Quiz newQuiz}) {
    answer = newQuiz;
    notifyListeners();
  }

  void removeAnswer() {
    answer = null;
    notifyListeners();
  }
}

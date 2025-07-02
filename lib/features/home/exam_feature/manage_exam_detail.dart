import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/common/loading_view.dart';
import 'package:social_app/features/auth/controller/auth_controller.dart';
import 'package:social_app/models/exam_model.dart';

class ManageExamDetail extends ConsumerStatefulWidget {
  final ExamModel exam;
  const ManageExamDetail({required this.exam, super.key});
  static route({required ExamModel exam}) => MaterialPageRoute(
        builder: (context) => ManageExamDetail(exam: exam),
      );
  @override
  ConsumerState<ManageExamDetail> createState() => _ManageExamDetailState();
}

class _ManageExamDetailState extends ConsumerState<ManageExamDetail> {
  List<ExamModel> displayExam = [];
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(currentUserDetailProvider).value;
    if (currentUser == null) {
      return const LoadingPage();
    }
    return const Placeholder();
  }
}

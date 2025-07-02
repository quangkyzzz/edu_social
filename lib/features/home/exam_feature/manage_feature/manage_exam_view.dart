import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:quick_quiz/quick_quiz.dart';
import 'package:social_app/common/UIConstants.dart';
import 'package:social_app/common/loading_view.dart';
import 'package:social_app/features/auth/controller/auth_controller.dart';
import 'package:social_app/models/exam_model.dart';
import 'package:social_app/provider/get_exam_provider.dart';
import 'package:social_app/theme/pallete.dart';

class ManageExamView extends ConsumerStatefulWidget {
  const ManageExamView({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const ManageExamView(),
      );
  @override
  ConsumerState<ManageExamView> createState() => _ManageExamViewState();
}

class _ManageExamViewState extends ConsumerState<ManageExamView> {
  List<ExamModel> displayExam = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<GetExamProvider>().getExam();
    });
  }

  @override
  Widget build(BuildContext context) {
    displayExam = [];
    final currentUser = ref.read(currentUserDetailProvider).value;
    if (currentUser == null) {
      return const LoadingPage();
    }
    _readProvider().exams.forEach((value) {
      if ((value.authorID == currentUser.uid)) {
        displayExam.add(value);
      }
    });
    return Scaffold(
      appBar: UIConstants.appBar(),
      body: _watchProvider().isLoading
          ? Center(child: CircularProgressIndicator())
          : displayExam.isEmpty
              ? Center(
                  child: Text(
                  'You did not create any exam!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ))
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 4);
                  },
                  itemCount: displayExam.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ManageExamItem(
                        name: displayExam[index].examName,
                        exam: displayExam[index],
                        text1: ' ${displayExam[index].questions.length} questions',
                        text2: 'Duration: ${_printDuration(displayExam[index].duration)}',
                      ),
                    );
                  },
                ),
    );
  }

  GetExamProvider _readProvider() {
    return context.read<GetExamProvider>();
  }

  GetExamProvider _watchProvider() {
    return context.watch<GetExamProvider>();
  }

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

class ManageExamItem extends StatelessWidget {
  final ExamModel exam;
  final String name;
  final String text1;
  final String text2;
  const ManageExamItem({
    super.key,
    required this.name,
    required this.text1,
    required this.text2,
    required this.exam,
  });

  @override
  Widget build(BuildContext context) {
    Quiz quiz = Quiz(
      timerDuration: exam.duration.inSeconds,
      questions: [
        ...exam.questions.map((question) {
          return QuestionModel(
            question: question.content,
            options: question.options,
            correctAnswerIndex: question.correctAnswerIndex,
          );
        })
      ],
    );
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      tileColor: Colors.grey[900],
      enableFeedback: true,
      onTap: () {
        // Navigator.push(
        //   context,
        //   ExamDetail.route(quiz),
        // );
      },
      leading: Icon(Icons.assignment, size: 46),
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
          const SizedBox(height: 4),
          Text(
            text1,
            style: const TextStyle(
              color: Pallete.whiteColor,
              fontSize: 14,
            ),
          ),
          Text(
            text2,
            style: const TextStyle(
              color: Pallete.whiteColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_quiz/quick_quiz.dart';
import 'package:social_app/common/UIConstants.dart';
import 'package:social_app/common/loading_view.dart';
import 'package:social_app/features/auth/controller/auth_controller.dart';
import 'package:social_app/features/home/exam_feature/score_page.dart';
import 'package:social_app/models/exam_model.dart';
import 'package:social_app/theme/pallete.dart';

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
    return Scaffold(
      appBar: UIConstants.appBar(),
      body: displayExam.isEmpty
          ? Center(
              child: Text(
              'There is no exam for you now!',
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
                  child: ManageExamWidget(
                    userId: currentUser.uid,
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

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

class ManageExamWidget extends StatelessWidget {
  final ExamModel exam;
  final String name;
  final String text1;
  final String text2;
  final String userId;
  const ManageExamWidget({
    super.key,
    required this.name,
    required this.text1,
    required this.text2,
    required this.exam,
    required this.userId,
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
      onTap: () async {
        if (2 != -1) {
          // for (int index = 0; index < quiz.questions.length; index++) {
          //   quiz.questions[index].selectedAnswerIndex = exam.historys[historyIndex].listAnswer[index];
          // }
          // await Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ScorePage(
          //       quiz: quiz,
          //       duration: exam.historys[historyIndex].durationTake.inSeconds,
          //     ), //ReviewAnswer(quiz: quiz),
          //   ),
          // );
        }
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

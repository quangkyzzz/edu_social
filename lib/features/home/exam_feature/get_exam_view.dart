import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_quiz/quick_quiz.dart';

import 'package:social_app/common/common.dart';
import 'package:social_app/features/home/exam_feature/exam_detail.dart';
import 'package:social_app/models/exam_model.dart';

import 'package:social_app/provider/get_exam_provider.dart';
import 'package:social_app/theme/pallete.dart';

class GetExamView extends StatefulWidget {
  const GetExamView({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const GetExamView(),
      );
  @override
  State<GetExamView> createState() => _GetExamViewState();
}

class _GetExamViewState extends State<GetExamView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<GetExamProvider>().getExam();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIConstants.appBar(),
      body: context.watch<GetExamProvider>().isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(height: 4);
              },
              itemCount: context.read<GetExamProvider>().exams.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ExamWidget(
                    name: _watchProvider().exams[index].examName,
                    exam: _readProvider().exams[index],
                    text1: ' ${_readProvider().exams[index].questions.length} questions',
                    text2: 'Duration: ${_printDuration(_readProvider().exams[index].duration)}',
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

  GetExamProvider _readProvider() {
    return context.read<GetExamProvider>();
  }

  GetExamProvider _watchProvider() {
    return context.watch<GetExamProvider>();
  }
}

class ExamWidget extends StatelessWidget {
  final ExamModel exam;
  final String name;
  final String text1;
  final String text2;
  const ExamWidget({
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
        Navigator.push(
          context,
          ExamDetail.route(quiz),
        );
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
              color: Pallete.whiteColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

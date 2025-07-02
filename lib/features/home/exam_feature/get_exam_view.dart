import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:quick_quiz/quick_quiz.dart';

import 'package:social_app/common/common.dart';
import 'package:social_app/features/auth/controller/auth_controller.dart';
import 'package:social_app/features/home/exam_feature/exam_detail.dart';
import 'package:social_app/features/home/exam_feature/score_page.dart';
import 'package:social_app/models/exam_model.dart';
import 'package:social_app/models/user_model.dart';

import 'package:social_app/provider/get_exam_provider.dart';
import 'package:social_app/route_observer.dart';
import 'package:social_app/theme/pallete.dart';

class GetExamView extends ConsumerStatefulWidget {
  const GetExamView({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const GetExamView(),
      );
  @override
  ConsumerState<GetExamView> createState() => _GetExamViewState();
}

class _GetExamViewState extends ConsumerState<GetExamView> implements RouteAware {
  List<ExamModel> displayExam = [];
  @override
  void initState() {
    super.initState();
    routeObserver.subscribe(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<GetExamProvider>().getExam();
    });
  }

  @override
  void didPop() async {
    print('qqq pop');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500));
      await _readProvider().getExam();
    });
  }

  @override
  void didPopNext() {
    print('qqq pop next');
  }

  @override
  void didPush() {
    print('qqq push');
    // TODO: implement didPush
  }

  @override
  void didPushNext() {
    print('qqq did push next');
    // TODO: implement didPushNext
  }

  GetExamProvider _readProvider() {
    return context.read<GetExamProvider>();
  }

  GetExamProvider _watchProvider() {
    return context.watch<GetExamProvider>();
  }

  @override
  Widget build(BuildContext context) {
    displayExam = [];
    final currentUser = ref.read(currentUserDetailProvider).value;
    if (currentUser == null) {
      return const LoadingPage();
    }
    _readProvider().exams.forEach((value) {
      if ((value.authorID == currentUser.uid) || (value.memberID.contains(currentUser.uid))) {
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
                      child: ExamWidget(
                        historyIndex: didCompleteExam(displayExam[index].historys, currentUser),
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  int didCompleteExam(List<History> hitorys, UserModel currentUser) {
    for (var history in hitorys) {
      if (history.memberID == currentUser.uid) {
        return hitorys.indexOf(history);
      }
    }
    return -1;
  }

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

class ExamWidget extends StatelessWidget {
  final ExamModel exam;
  final String name;
  final String text1;
  final String text2;
  final String userId;
  final int historyIndex;
  const ExamWidget({
    super.key,
    required this.name,
    required this.text1,
    required this.text2,
    required this.exam,
    required this.userId,
    required this.historyIndex,
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
        if (historyIndex != -1) {
          for (int index = 0; index < quiz.questions.length; index++) {
            quiz.questions[index].selectedAnswerIndex = exam.historys[historyIndex].listAnswer[index];
          }
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScorePage(
                quiz: quiz,
                duration: exam.historys[historyIndex].durationTake.inSeconds,
              ), //ReviewAnswer(quiz: quiz),
            ),
          );
        } else {
          quiz.questions.forEach((ques) {
            ques.selectedAnswerIndex = -1;
          });
          await Navigator.push(
            context,
            ExamDetail.route(quiz, exam, userId),
          );
        }
      },
      leading:
          historyIndex != -1 ? Icon(Icons.assignment_turned_in_outlined, size: 46) : Icon(Icons.assignment, size: 46),
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

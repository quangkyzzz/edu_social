import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_quiz/quick_quiz.dart';
import 'package:social_app/common/UIConstants.dart';
import 'package:social_app/common/loading_view.dart';
import 'package:social_app/constants/appwrite_constants.dart';
import 'package:social_app/features/auth/controller/auth_controller.dart';
import 'package:social_app/features/explore/controller/explore_controller.dart';
import 'package:social_app/features/home/exam_feature/manage_feature/manage_score_page.dart';
import 'package:social_app/models/exam_model.dart';
import 'package:social_app/models/user_model.dart';
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
  List<History> hitorys = [];
  List<UserModel> participantCompleted = [];
  List<UserModel> allFollowing = [];
  @override
  Widget build(BuildContext context) {
    hitorys = widget.exam.historys;
    final currentUser = ref.read(currentUserDetailProvider).value;
    if (currentUser == null) {
      return const LoadingPage();
    }
    allFollowing = ref.watch(getFollowingUserProvider(currentUser.following)).value ?? [];
    for (var history in hitorys) {
      UserModel completedUser = allFollowing.firstWhere(
        (user) => user.uid == history.memberID,
        orElse: () {
          return UserModel(
            uid: 'null',
            email: '',
            name: '',
            profilePic: '',
            bannerPic: '',
            bio: '',
            followers: [],
            following: [],
            isBlue: false,
          );
        },
      );
      if (completedUser.uid != 'null') {
        participantCompleted.add(completedUser);
      }
    }
    return Scaffold(
      appBar: UIConstants.appBar(),
      body: participantCompleted.isEmpty
          ? Center(
              child: Text(
              'No one has completed this exam yet!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ))
          : ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(height: 4);
              },
              itemCount: hitorys.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ManageExamWidget(
                    durationTake: hitorys[index].durationTake.inSeconds,
                    listAnswer: hitorys[index].listAnswer,
                    profilePic: participantCompleted[index].profilePic,
                    userId: currentUser.uid,
                    name: participantCompleted[index].name,
                    exam: widget.exam,
                    text1: participantCompleted[index].email,
                    text2: 'Duration take: ${_printDuration(hitorys[index].durationTake)}',
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
  final String profilePic;
  final String name;
  final String text1;
  final String text2;
  final List<int> listAnswer;
  final int durationTake;
  final String userId;

  const ManageExamWidget({
    super.key,
    required this.name,
    required this.text1,
    required this.text2,
    required this.exam,
    required this.userId,
    required this.profilePic,
    required this.listAnswer,
    required this.durationTake,
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
        for (int index = 0; index < quiz.questions.length; index++) {
          quiz.questions[index].selectedAnswerIndex = listAnswer[index];
        }
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ManageScorePage(
              quiz: quiz,
              duration: durationTake,
            ), //ReviewAnswer(quiz: quiz),
          ),
        );
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(AppwriteConstants.imageUrl(profilePic)),
        radius: 20,
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

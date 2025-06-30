import 'package:quick_quiz/quick_quiz.dart';
import 'package:social_app/common/common.dart';
import 'package:social_app/features/home/exam_feature/create_exam_view.dart';
import 'package:social_app/features/home/exam_feature/get_exam_view.dart';
import 'package:social_app/features/home/test_detail.dart';
import 'package:social_app/features/meeting/widget/meeting_button.dart';
import 'package:social_app/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExamView extends ConsumerStatefulWidget {
  const ExamView({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const ExamView(),
      );

  @override
  ConsumerState<ExamView> createState() => _ExamViewState();
}

class _ExamViewState extends ConsumerState<ExamView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIConstants.appBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MeetingButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CreateExamView.route(),
                  );
                },
                icon: Icons.videocam,
                text: 'Create a exam',
              ),
              MeetingButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    GetExamView.route(),
                  );
                },
                icon: Icons.add_box_outlined,
                text: 'Join a exam',
              ),
            ],
          ),
          const SizedBox(
            height: 70,
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  final String avatar;
  final String name;
  final String text1;
  final String text2;
  const NewWidget({
    super.key,
    required this.avatar,
    required this.name,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, TestDetailView.route());
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(avatar),
        radius: 30,
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
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

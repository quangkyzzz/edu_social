import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:social_app/common/common.dart';

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
          : ListView.builder(
              itemCount: context.read<GetExamProvider>().exams.length,
              itemBuilder: (context, index) {
                return ExamWidget(
                  avatar: 'https://i.imgur.com/CbhBdjn.png',
                  name: _watchProvider().exams[index].examName,
                  text1: 'text1',
                  text2: 'text2',
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
}

class ExamWidget extends StatelessWidget {
  final String avatar;
  final String name;
  final String text1;
  final String text2;
  const ExamWidget({
    super.key,
    required this.avatar,
    required this.name,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
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

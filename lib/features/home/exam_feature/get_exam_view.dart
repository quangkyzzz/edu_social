import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:social_app/common/common.dart';

import 'package:social_app/provider/get_exam_provider.dart';

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
          : Column(
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {},
                ),
              ],
            ),
    );
  }
}

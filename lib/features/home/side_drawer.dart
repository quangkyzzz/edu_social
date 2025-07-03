import 'package:social_app/constants/constants.dart';
import 'package:social_app/features/home/exam_feature/exam_view.dart';
import 'package:social_app/features/home/chat_view.dart';
import 'package:social_app/features/meeting/view/meeting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/common/loading_view.dart';
import 'package:social_app/features/auth/controller/auth_controller.dart';
import 'package:social_app/features/user_profile/view/user_profile_view.dart';
import 'package:social_app/theme/pallete.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailProvider).value;
    if (currentUser == null) {
      return const Loader();
    }

    return SafeArea(
      child: Drawer(
        backgroundColor: Pallete.backgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: const Icon(
                Icons.person,
                size: 30,
              ),
              title: const Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  UserProfileView.route(currentUser),
                );
              },
            ),
            ListTile(
              leading: Image.asset(
                AssetsConstants.meetingIcon,
                color: Pallete.whiteColor,
                width: 30,
              ),
              title: const Text(
                'Meeting',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MeetingView.route(),
                );
              },
            ),
            ListTile(
              leading: Image.asset(
                AssetsConstants.testIcon,
                width: 35,
                color: Pallete.whiteColor,
              ),
              title: const Text(
                'Exam',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  ExamView.route(),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.forum),
              title: const Text(
                'Chat',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  ChatPage.route(),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                ref.read(authControllerProvider.notifier).logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

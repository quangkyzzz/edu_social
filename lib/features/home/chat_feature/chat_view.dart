import 'package:social_app/features/home/chat_feature/new_chat/Screens/ChatPage.dart';
import 'package:social_app/features/home/group_post.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';

class ChatView extends StatefulWidget {
  final UserModel currentUser;
  const ChatView({super.key, required this.currentUser});

  static route(UserModel currentUser) => MaterialPageRoute(
        builder: (context) => ChatView(currentUser: currentUser),
      );
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  AppTheme theme = AppTheme();
  late final ChatController _chatController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // ChatController should be disposed to avoid memory leaks
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatPage(currentUser: widget.currentUser);
  }
}

class NewWidget2 extends StatelessWidget {
  final String avatar;
  final String name;
  final String text1;
  final String text2;
  const NewWidget2({
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
        Navigator.push(context, GroupPostView.route());
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

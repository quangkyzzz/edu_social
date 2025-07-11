import 'package:social_app/features/home/chat_feature/new_chat/group_chats/create_group/add_members.dart';
import 'package:social_app/features/home/chat_feature/new_chat/group_chats/group_chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/user_model.dart';

class GroupChatHomeScreen extends StatefulWidget {
  final UserModel currentUser;
  const GroupChatHomeScreen({super.key, required this.currentUser});

  @override
  _GroupChatHomeScreenState createState() => _GroupChatHomeScreenState();
}

class _GroupChatHomeScreenState extends State<GroupChatHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = true;

  List groupList = [];

  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    String uid = widget.currentUser.uid;

    await _firestore.collection('users').doc(uid).collection('groups').get().then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Groups"),
      ),
      body: isLoading
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GroupChatRoom(
                        currentUser: widget.currentUser,
                        groupName: groupList[index]['name'],
                        groupChatId: groupList[index]['id'],
                      ),
                    ),
                  ),
                  leading: Icon(Icons.group),
                  title: Text(groupList[index]['name']),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddMembersInGroup(
              currentUser: widget.currentUser,
            ),
          ),
        ),
        tooltip: "Create Group",
      ),
    );
  }
}

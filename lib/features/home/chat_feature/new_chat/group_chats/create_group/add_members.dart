import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/constants/appwrite_constants.dart';
import 'package:social_app/features/explore/controller/explore_controller.dart';
import 'package:social_app/features/home/chat_feature/new_chat/group_chats/create_group/create_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/user_model.dart';

class AddMembersInGroup extends ConsumerStatefulWidget {
  final UserModel currentUser;
  const AddMembersInGroup({super.key, required this.currentUser});

  @override
  ConsumerState<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends ConsumerState<AddMembersInGroup> {
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> membersList = [];
  List<UserModel> followingUserList = [];
  List<UserModel> filteredStudents = [];
  bool isLoading = false;
  Map<String, dynamic> userMap = {};

  @override
  void initState() {
    super.initState();
    followingUserList = ref.read(getFollowingUserProvider(widget.currentUser.following)).value ?? [];
    filteredStudents = followingUserList;
    getCurrentUserDetails(widget.currentUser.uid);
  }

  void getCurrentUserDetails(String userID) async {
    await _firestore.collection('users').doc(userID).get().then((map) {
      setState(() {
        membersList.add({
          "name": map['name'],
          "email": map['email'],
          "uid": map['uid'],
          "isAdmin": true,
        });
      });
    });
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await _firestore.collection('users').where("email", isEqualTo: _search.text).get().then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
    });
  }

  void onResultTap(Map newUser) {
    bool isAlreadyExist = false;

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == newUser['uid']) {
        isAlreadyExist = true;
      }
    }

    if (!isAlreadyExist) {
      setState(() {
        membersList.add({
          "name": newUser['name'],
          "email": newUser['email'],
          "uid": newUser['uid'],
          "isAdmin": false,
        });

        // userMap = {};
      });
    }
  }

  void onRemoveMembers(int index) {
    if (membersList[index]['uid'] != widget.currentUser.uid) {
      setState(() {
        membersList.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Members"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: membersList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => onRemoveMembers(index),
                    leading: Icon(Icons.account_circle),
                    title: Text(membersList[index]['name']),
                    subtitle: Text(membersList[index]['email']),
                    trailing: Icon(Icons.close),
                  );
                },
              ),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 14,
                width: size.width / 1.15,
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            isLoading
                ? Container(
                    height: size.height / 12,
                    width: size.height / 12,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: onSearch,
                    child: Text("Search"),
                  ),

            ListView.builder(
              shrinkWrap: true,
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final student = filteredStudents[index];

                return GestureDetector(
                  onTap: () {
                    userMap = {};
                    userMap.addAll({'uid': student.uid});
                    userMap.addAll({'status': 'online'});
                    userMap.addAll({'name': student.name});
                    userMap.addAll({'email': student.email});
                    onResultTap(userMap);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(AppwriteConstants.imageUrl(student.profilePic)),
                        radius: 20,
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(student.name),
                          Text(
                            student.email,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            // userMap != null
            //     ? ListTile(
            //         onTap: onResultTap,
            //         leading: Icon(Icons.account_box),
            //         title: Text(userMap!['name']),
            //         subtitle: Text(userMap!['email']),
            //         trailing: Icon(Icons.add),
            //       )
            //     : SizedBox(),
          ],
        ),
      ),
      floatingActionButton: membersList.length >= 2
          ? FloatingActionButton(
              child: Icon(Icons.forward),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreateGroup(
                    currentUser: widget.currentUser,
                    membersList: membersList,
                  ),
                ),
              ),
            )
          : SizedBox(),
    );
  }
}

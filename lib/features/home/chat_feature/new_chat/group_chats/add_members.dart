import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/constants/appwrite_constants.dart';
import 'package:social_app/features/explore/controller/explore_controller.dart';
import 'package:social_app/models/user_model.dart';

class AddMembersINGroup extends ConsumerStatefulWidget {
  final String groupChatId, name;
  final List membersList;
  final UserModel currentUser;
  const AddMembersINGroup({required this.currentUser, required this.name, required this.membersList, required this.groupChatId, super.key});

  @override
  ConsumerState createState() => _AddMembersINGroupState();
}

class _AddMembersINGroupState extends ConsumerState<AddMembersINGroup> {
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserModel> followingUserList = [];
  List<UserModel> filteredStudents = [];
  Map<String, dynamic> userMap = {};
  bool isLoading = false;
  List membersList = [];

  @override
  void initState() {
    super.initState();
    followingUserList = ref.read(getFollowingUserProvider(widget.currentUser.following)).value ?? [];
    filteredStudents = followingUserList;
    membersList = widget.membersList;
  }

  void onSearch(String query) async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      filteredStudents = followingUserList.where((student) {
        return student.name.toLowerCase().contains(query) || student.email.toLowerCase().contains(query);
      }).toList();
      isLoading = false;
    });
  }

  void onAddMembers(Map addMap) async {
    membersList.add(addMap);

    await _firestore.collection('groups').doc(widget.groupChatId).update({
      "members": membersList,
    });

    await _firestore
        .collection('users')
        .doc(addMap['uid'])
        .collection('groups')
        .doc(widget.groupChatId)
        .set({"name": widget.name, "id": widget.groupChatId});
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
                    onPressed: () {
                      onSearch(_search.text);
                    },
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
                    onAddMembers(userMap);
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
            //         onTap: onAddMembers,
            //         leading: Icon(Icons.account_box),
            //         title: Text(userMap!['name']),
            //         subtitle: Text(userMap!['email']),
            //         trailing: Icon(Icons.add),
            //       )
            //     : SizedBox(),
          ],
        ),
      ),
    );
  }
}

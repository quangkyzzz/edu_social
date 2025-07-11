// ignore_for_file: public_member_api_docs, sort_constructors_first, no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/constants/appwrite_constants.dart';
import 'package:social_app/features/explore/controller/explore_controller.dart';

import 'package:social_app/features/home/chat_feature/new_chat/Screens/ChatRoom.dart';
import 'package:social_app/features/home/chat_feature/new_chat/group_chats/group_chat_screen.dart';
import 'package:social_app/models/user_model.dart';

class ChatPage extends ConsumerStatefulWidget {
  final UserModel currentUser;
  const ChatPage({
    super.key,
    required this.currentUser,
  });
  @override
  ConsumerState createState() => CreateChatPageState();
}

class CreateChatPageState extends ConsumerState<ChatPage> with WidgetsBindingObserver {
  Map<String, dynamic> userMap = {};
  bool isLoading = false;
  List<UserModel> followingUserList = [];
  List<UserModel> filteredStudents = [];
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    followingUserList = ref.read(getFollowingUserProvider(widget.currentUser.following)).value ?? [];
    filteredStudents = followingUserList;
    // setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(widget.currentUser.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch(String query) async {
    //FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });
    setState(() {
      filteredStudents = followingUserList.where((student) {
        return student.name.toLowerCase().contains(query) || student.email.toLowerCase().contains(query);
      }).toList();
      isLoading = false;
    });

    // await _firestore.collection('users').get().then((value) {
    //   setState(() {
    //     userMap = value.docs[0].data();
    //     isLoading = false;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        //actions: [IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context))],
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
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
                ElevatedButton(
                  onPressed: () {
                    onSearch(_search.text);
                  },
                  child: Text("Search"),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];

                    return GestureDetector(
                      onTap: () {
                        String roomId = chatRoomId(
                          widget.currentUser.name,
                          student.name,
                        );
                        userMap = {};
                        userMap.addAll({'uid': student.uid});
                        userMap.addAll({'status': 'online'});
                        userMap.addAll({'name': student.name});
                        userMap.addAll({'email': student.email});
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatRoom(
                              currentUser: widget.currentUser,
                              chatRoomId: roomId,
                              userMap: userMap,
                            ),
                          ),
                        );
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
                //         onTap: () {
                //           String roomId = chatRoomId(
                //             widget.currentUser.name,
                //             userMap['name'],
                //           );

                //           Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (_) => ChatRoom(
                //                 currentUser: widget.currentUser,
                //                 chatRoomId: roomId,
                //                 userMap: userMap,
                //               ),
                //             ),
                //           );
                //         },
                //         leading: Icon(Icons.account_box, color: Colors.black),
                //         title: Text(
                //           userMap['name'],
                //           style: TextStyle(
                //             color: Colors.black,
                //             fontSize: 17,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //         subtitle: Text(userMap['email']),
                //         trailing: Icon(Icons.chat, color: Colors.black),
                //       )
                //     : Container(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.group),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GroupChatHomeScreen(
              currentUser: widget.currentUser,
            ),
          ),
        ),
      ),
    );
  }
}

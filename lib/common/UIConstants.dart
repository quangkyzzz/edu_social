import 'package:social_app/features/explore/view/explore_view.dart';
import 'package:social_app/features/explore/view/following_view.dart';
import 'package:social_app/features/post/widgets/post_list.dart';
import 'package:flutter/material.dart';
import 'package:social_app/theme/theme.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'EduSocial',
        style: TextStyle(color: Pallete.blueColor),
      ),
    );
  }

  static List<Widget> bottomTabBarPages = [
    const PostList(),
    const ExploreView(),
    FollowingView(),
  ];
}

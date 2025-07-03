import 'package:flutter/material.dart';
import 'package:social_app/theme/pallete.dart';

class AppTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.backgroundColor,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.blueColor,
    ),
  );

  Color flashingCircleDarkColor = Colors.grey;
  Color flashingCircleBrightColor = const Color(0xffeeeeee);
  TextStyle incomingChatLinkTitleStyle = const TextStyle(color: Colors.black);
  TextStyle outgoingChatLinkTitleStyle = const TextStyle(color: Colors.white);
  TextStyle outgoingChatLinkBodyStyle = const TextStyle(color: Colors.white);
  TextStyle incomingChatLinkBodyStyle = const TextStyle(color: Colors.white);
  double elevation = 1;
  Color repliedTitleTextColor = Colors.white;
  Color? swipeToReplyIconColor = Colors.white;
  Color textFieldTextColor = Colors.white;
  Color appBarColor = const Color(0xff1d1b25);
  Color backArrowColor = Colors.white;
  Color backgroundColor = const Color(0xff272336);
  Color replyDialogColor = const Color(0xff272336);
  Color linkPreviewOutgoingChatColor = const Color(0xff272336);
  Color linkPreviewIncomingChatColor = const Color(0xff9f85ff);
  TextStyle linkPreviewIncomingTitleStyle = const TextStyle();
  TextStyle linkPreviewOutgoingTitleStyle = const TextStyle();
  Color replyTitleColor = Colors.white;
  Color textFieldBackgroundColor = const Color(0xff383152);
  Color outgoingChatBubbleColor = const Color(0xff9f85ff);
  Color inComingChatBubbleColor = const Color(0xff383152);
  Color reactionPopupColor = const Color(0xff383152);
  Color replyPopupColor = const Color(0xff383152);
  Color replyPopupButtonColor = Colors.white;
  Color replyPopupTopBorderColor = Colors.black54;
  Color reactionPopupTitleColor = Colors.white;
  Color inComingChatBubbleTextColor = Colors.white;
  Color repliedMessageColor = const Color(0xff9f85ff);
  Color closeIconColor = Colors.white;
  Color shareIconBackgroundColor = const Color(0xff383152);
  Color sendButtonColor = Colors.white;
  Color cameraIconColor = const Color(0xff757575);
  Color galleryIconColor = const Color(0xff757575);
  Color recorderIconColor = const Color(0xff757575);
  Color stopIconColor = const Color(0xff757575);
  Color replyMessageColor = Colors.grey;
  Color appBarTitleTextStyle = Colors.white;
  Color messageReactionBackGroundColor = const Color(0xff383152);
  Color messageReactionBorderColor = const Color(0xff272336);
  Color verticalBarColor = const Color(0xff383152);
  Color chatHeaderColor = Colors.white;
  Color themeIconColor = Colors.white;
  Color shareIconColor = Colors.white;
  Color messageTimeIconColor = Colors.white;
  Color messageTimeTextColor = Colors.white;
  Color waveformBackgroundColor = const Color(0xff383152);
  Color waveColor = Colors.white;
  Color replyMicIconColor = Colors.white;
}

import 'package:provider/provider.dart';
import 'package:social_app/core/restart_widget.dart';
import 'package:social_app/features/meeting/view/video_call_view.dart';
import 'package:social_app/features/post/view/create_post_view.dart';
import 'package:social_app/provider/get_exam_provider.dart';
import 'common/common.dart';
import 'package:social_app/features/auth/controller/auth_controller.dart';
import 'package:social_app/features/auth/view/login_view.dart';
import 'package:social_app/features/auth/view/signup_view.dart';
import 'package:social_app/features/home/home_view.dart';
import 'package:social_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    RestartWidget(
      child: const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GetExamProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Edu Social',
        theme: AppTheme.theme,
        home: ref.watch(currentUserAccountProvider).when(
              data: (user) {
                if (user != null) {
                  return const HomeView();
                } else {
                  return const LoginView();
                }
              },
              error: (e, st) {
                return ErrorPage(error: e.toString());
              },
              loading: () => const LoadingPage(),
            ),
        routes: {
          '/login/': (context) => const LoginView(),
          '/sign-up/': (context) => const SignupView(),
          '/home/': (context) => const HomeView(),
          '/new-post/': (context) => const CreatePostView(),
          '/video-call/': (context) => const VideoCallView(),
        },
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'config/firebase_config.dart';
import 'firebase_options.dart';
import 'screens/admin_page.dart';
import 'screens/auth_page.dart';
import 'screens/memorial_home_page.dart';
import 'screens/memories_page.dart';
import 'screens/share_story_page.dart';
import 'services/auth_service.dart';
import 'services/post_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (FirebaseConfig.enabled) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  final auth = AuthService();
  final posts = PostService(auth);
  runApp(ColetteApp(auth: auth, posts: posts));
}

class ColetteApp extends StatefulWidget {
  const ColetteApp({
    super.key,
    required this.auth,
    required this.posts,
  });

  final AuthService auth;
  final PostService posts;

  @override
  State<ColetteApp> createState() => _ColetteAppState();
}

class _ColetteAppState extends State<ColetteApp> {
  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    refreshListenable: widget.auth,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MemorialHomePage(auth: widget.auth),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => AuthPage(auth: widget.auth),
      ),
      GoRoute(
        path: '/memories',
        builder: (context, state) => MemoriesPage(
          auth: widget.auth,
          posts: widget.posts,
        ),
      ),
      GoRoute(
        path: '/share',
        builder: (context, state) => ShareStoryPage(
          auth: widget.auth,
          posts: widget.posts,
        ),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => AdminPage(
          auth: widget.auth,
          posts: widget.posts,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.auth, widget.posts]),
      builder: (context, _) {
        return MaterialApp.router(
          title: 'In Loving Memory of Collete Marie Williams',
          theme: AppTheme.light,
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

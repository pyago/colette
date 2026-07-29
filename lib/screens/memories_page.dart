import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/post.dart';
import '../services/auth_service.dart';
import '../services/post_service.dart';
import '../theme/app_theme.dart';
import '../widgets/post_card.dart';

class MemoriesPage extends StatelessWidget {
  const MemoriesPage({
    super.key,
    required this.auth,
    required this.posts,
  });

  final AuthService auth;
  final PostService posts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memories'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          TextButton(
            onPressed: () => context.go(auth.isSignedIn ? '/share' : '/auth'),
            child: const Text('Share'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: StreamBuilder<List<Post>>(
            stream: posts.watchApproved(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final items = snap.data!;
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'No public memories yet. Be the first to share.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.muted,
                        ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: items.length,
                itemBuilder: (context, i) => PostCard(post: items[i]),
              );
            },
          ),
        ),
      ),
    );
  }
}

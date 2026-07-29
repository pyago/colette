import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/post.dart';
import '../services/auth_service.dart';
import '../services/post_service.dart';
import '../theme/app_theme.dart';
import '../widgets/post_card.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({
    super.key,
    required this.auth,
    required this.posts,
  });

  final AuthService auth;
  final PostService posts;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _newPost = TextEditingController();
  PostType _type = PostType.text;
  String? _status;

  @override
  void dispose() {
    _newPost.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    try {
      await widget.posts.createAdminPost(body: _newPost.text, type: _type);
      _newPost.clear();
      setState(() => _status = 'Published.');
    } catch (e) {
      setState(() => _status = e.toString());
    }
  }

  Future<void> _reply(Post post) async {
    final controller = TextEditingController(
      text: post.adminReply ??
          'Thank you so much for sharing this memory of Collete. It means the world to us. — Kwai',
    );
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reply to author'),
        content: TextField(
          controller: controller,
          minLines: 3,
          maxLines: 6,
          decoration: InputDecoration(
            labelText: 'Message to ${post.authorName}',
            helperText: post.authorEmail,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save reply'),
          ),
        ],
      ),
    );
    if (ok == true && controller.text.trim().isNotEmpty) {
      await widget.posts.replyToAuthor(
        postId: post.id,
        message: controller.text,
      );
      final mail = Uri(
        scheme: 'mailto',
        path: post.authorEmail,
        queryParameters: {
          'subject': 'Thank you for your memory of Collete',
          'body': controller.text,
        },
      );
      if (await canLaunchUrl(mail)) {
        await launchUrl(mail);
      }
    }
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.auth.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin')),
        body: const Center(child: Text('Admin access only.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await widget.auth.signOut();
              if (context.mounted) context.go('/');
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Create a post',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Admin posts publish immediately.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.muted,
                    ),
              ),
              const SizedBox(height: 12),
              SegmentedButton<PostType>(
                segments: const [
                  ButtonSegment(value: PostType.text, label: Text('Text')),
                  ButtonSegment(value: PostType.image, label: Text('Image')),
                  ButtonSegment(value: PostType.video, label: Text('Video')),
                ],
                selected: {_type},
                onSelectionChanged: (s) => setState(() => _type = s.first),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _newPost,
                minLines: 3,
                maxLines: 8,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(labelText: 'Post content'),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed:
                    _newPost.text.trim().isEmpty ? null : _createPost,
                child: const Text('Publish'),
              ),
              if (_status != null) ...[
                const SizedBox(height: 8),
                Text(_status!),
              ],
              const SizedBox(height: 28),
              Text(
                'Moderation queue',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              StreamBuilder<List<Post>>(
                stream: widget.posts.watchAllForAdmin(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final items = snap.data!;
                  if (items.isEmpty) {
                    return const Text('No submissions yet.');
                  }
                  return Column(
                    children: [
                      for (final post in items)
                        PostCard(
                          post: post,
                          showStatus: true,
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              if (post.status == PostStatus.pending) ...[
                                OutlinedButton(
                                  onPressed: () => widget.posts.setStatus(
                                    post.id,
                                    PostStatus.approved,
                                  ),
                                  child: const Text('Approve'),
                                ),
                                OutlinedButton(
                                  onPressed: () => widget.posts.setStatus(
                                    post.id,
                                    PostStatus.rejected,
                                  ),
                                  child: const Text('Reject'),
                                ),
                              ],
                              if (post.authorEmail.isNotEmpty)
                                OutlinedButton(
                                  onPressed: () => _reply(post),
                                  child: Text(
                                    post.adminReply == null
                                        ? 'Thank / reply'
                                        : 'Edit reply',
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

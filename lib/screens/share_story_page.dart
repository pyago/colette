import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/post.dart';
import '../services/auth_service.dart';
import '../services/post_service.dart';
import '../theme/app_theme.dart';

class ShareStoryPage extends StatefulWidget {
  const ShareStoryPage({
    super.key,
    required this.auth,
    required this.posts,
  });

  final AuthService auth;
  final PostService posts;

  @override
  State<ShareStoryPage> createState() => _ShareStoryPageState();
}

class _ShareStoryPageState extends State<ShareStoryPage> {
  final _body = TextEditingController();
  final _mediaUrl = TextEditingController();
  PostType _type = PostType.text;
  bool _busy = false;
  String? _message;

  @override
  void dispose() {
    _body.dispose();
    _mediaUrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await widget.posts.submitStory(
        body: _body.text,
        type: _type,
        mediaUrl: _mediaUrl.text.trim().isEmpty ? null : _mediaUrl.text.trim(),
      );
      setState(() {
        _message =
            'Thank you. Your story was submitted and is awaiting approval by Kwai.';
        _body.clear();
        _mediaUrl.clear();
      });
    } catch (e) {
      setState(() => _message = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.auth.isSignedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/auth');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Share a story'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Share a memory, prayer, or message in honor of Collete. '
                'Submissions are reviewed before they appear publicly. '
                'Kwai may reply to thank you.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.muted,
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 20),
              SegmentedButton<PostType>(
                segments: const [
                  ButtonSegment(value: PostType.text, label: Text('Text')),
                  ButtonSegment(value: PostType.image, label: Text('Image')),
                  ButtonSegment(value: PostType.video, label: Text('Video')),
                ],
                selected: {_type},
                onSelectionChanged: (s) => setState(() => _type = s.first),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _body,
                minLines: 5,
                maxLines: 12,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Your story',
                  alignLabelWithHint: true,
                ),
              ),
              if (_type != PostType.text) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _mediaUrl,
                  decoration: InputDecoration(
                    labelText: _type == PostType.image
                        ? 'Image URL (upload coming after Firebase Storage)'
                        : 'Video URL (upload coming after Firebase Storage)',
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_message!),
                ),
              FilledButton(
                onPressed: _busy || _body.text.trim().isEmpty ? null : _submit,
                child: const Text('Submit for review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

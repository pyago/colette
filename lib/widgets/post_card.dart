import 'package:flutter/material.dart';

import '../models/post.dart';
import '../theme/app_theme.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    this.showStatus = false,
    this.trailing,
  });

  final Post post;
  final bool showStatus;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    post.authorName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (showStatus)
                  Chip(
                    label: Text(post.status.name),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(post.createdAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.muted,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              post.body,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.55,
                  ),
            ),
            if (post.mediaUrl != null && post.mediaUrl!.isNotEmpty) ...[
              const SizedBox(height: 12),
              if (post.type == PostType.image)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.mediaUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Text(
                      'Image: ${post.mediaUrl}',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ),
                )
              else
                Text(
                  '${post.type.name}: ${post.mediaUrl}',
                  style: const TextStyle(color: AppColors.muted),
                ),
            ],
            if (post.adminReply != null && post.adminReply!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.softBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From ${post.adminRepliedBy ?? 'Kwai'}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(post.adminReply!),
                  ],
                ),
              ),
            ],
            if (trailing != null) ...[
              const SizedBox(height: 12),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../config/admin_config.dart';
import '../config/firebase_config.dart';
import '../models/post.dart';
import 'auth_service.dart';

class PostService extends ChangeNotifier {
  PostService(this._auth);

  final AuthService _auth;

  final List<Post> _localPosts = [
    Post(
      id: 'welcome',
      authorId: 'admin',
      authorName: AdminConfig.ownerDisplayName,
      authorEmail: AdminConfig.ownerEmail,
      type: PostType.text,
      status: PostStatus.approved,
      createdAt: DateTime(2025, 8, 6),
      body:
          'Welcome to Collete\'s memorial. Family and friends are invited to '
          'share photographs, stories, prayers, and messages in her honor.',
    ),
  ];

  CollectionReference<Map<String, dynamic>> get _posts =>
      FirebaseFirestore.instance.collection('posts');

  Stream<List<Post>> watchApproved() {
    if (!FirebaseConfig.enabled) {
      return Stream.value(
        _localPosts.where((p) => p.status == PostStatus.approved).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
      );
    }
    return _posts
        .where('status', isEqualTo: PostStatus.approved.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => Post.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Stream<List<Post>> watchPending() {
    if (!FirebaseConfig.enabled) {
      return Stream.value(
        _localPosts.where((p) => p.status == PostStatus.pending).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
      );
    }
    return _posts
        .where('status', isEqualTo: PostStatus.pending.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => Post.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Stream<List<Post>> watchAllForAdmin() {
    if (!FirebaseConfig.enabled) {
      return Stream.value(
        List<Post>.from(_localPosts)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
      );
    }
    return _posts.orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs
              .map((d) => Post.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Future<void> submitStory({
    required String body,
    PostType type = PostType.text,
    String? mediaUrl,
  }) async {
    final user = _auth.user;
    if (user == null) {
      throw StateError('Sign in to share a story.');
    }

    final post = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorId: user.uid,
      authorName: user.displayName?.trim().isNotEmpty == true
          ? user.displayName!
          : user.email.split('@').first,
      authorEmail: user.email,
      type: type,
      status: PostStatus.pending,
      createdAt: DateTime.now(),
      body: body.trim(),
      mediaUrl: mediaUrl,
    );

    if (!FirebaseConfig.enabled) {
      _localPosts.insert(0, post);
      notifyListeners();
      return;
    }

    await _posts.add(post.toMap());
  }

  Future<void> createAdminPost({
    required String body,
    PostType type = PostType.text,
    String? mediaUrl,
  }) async {
    final user = _auth.user;
    if (user == null || !user.isAdmin) {
      throw StateError('Admin only.');
    }

    final post = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorId: user.uid,
      authorName: user.displayName ?? AdminConfig.ownerDisplayName,
      authorEmail: user.email,
      type: type,
      status: PostStatus.approved,
      createdAt: DateTime.now(),
      body: body.trim(),
      mediaUrl: mediaUrl,
    );

    if (!FirebaseConfig.enabled) {
      _localPosts.insert(0, post);
      notifyListeners();
      return;
    }

    await _posts.add(post.toMap());
  }

  Future<void> setStatus(String postId, PostStatus status) async {
    if (!_auth.isAdmin) throw StateError('Admin only.');

    if (!FirebaseConfig.enabled) {
      final i = _localPosts.indexWhere((p) => p.id == postId);
      if (i >= 0) {
        _localPosts[i] = _localPosts[i].copyWith(status: status);
        notifyListeners();
      }
      return;
    }

    await _posts.doc(postId).update({'status': status.name});
  }

  Future<void> replyToAuthor({
    required String postId,
    required String message,
  }) async {
    if (!_auth.isAdmin) throw StateError('Admin only.');
    final repliedBy =
        _auth.user?.displayName ?? AdminConfig.ownerDisplayName;
    final now = DateTime.now();

    if (!FirebaseConfig.enabled) {
      final i = _localPosts.indexWhere((p) => p.id == postId);
      if (i >= 0) {
        _localPosts[i] = _localPosts[i].copyWith(
          adminReply: message.trim(),
          adminRepliedAt: now,
          adminRepliedBy: repliedBy,
        );
        notifyListeners();
      }
      return;
    }

    await _posts.doc(postId).update({
      'adminReply': message.trim(),
      'adminRepliedAt': now.toIso8601String(),
      'adminRepliedBy': repliedBy,
    });
  }
}

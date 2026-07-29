/// Emails allowed to use the admin console (approve/reject, create posts, reply).
class AdminConfig {
  static const adminEmails = <String>{
    'paul.yago@gmail.com',
    'kibawaf1990@gmail.com', // Kwai — owner (case-normalized)
  };

  /// Primary owner contact for thank-you / follow-up replies.
  static const ownerEmail = 'kibawaF1990@gmail.com';
  static const ownerDisplayName = 'Kwai';

  static bool isAdmin(String? email) {
    if (email == null || email.isEmpty) return false;
    return adminEmails.contains(email.trim().toLowerCase());
  }
}

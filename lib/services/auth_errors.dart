import 'package:firebase_auth/firebase_auth.dart';

import '../config/site_config.dart';

/// Maps Firebase / Google sign-in failures to a short on-screen message.
String describeAuthError(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'unauthorized-domain':
        return 'Google sign-in is blocked on this address because '
            '${SiteConfig.customDomain} is not in Firebase authorized domains. '
            'Add ${SiteConfig.customDomain} and ${SiteConfig.customDomainWww} at '
            'Authentication → Settings → Authorized domains, then also add '
            'https://${SiteConfig.customDomain} as an Authorized JavaScript origin '
            'on the Google Cloud OAuth web client.';
      case 'popup-closed-by-user':
        return 'Sign-in was cancelled.';
      case 'popup-blocked':
        return 'The sign-in popup was blocked. Allow popups for this site and try again.';
      case 'operation-not-allowed':
        return 'That sign-in method is not enabled in the Firebase console.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with this email using a different sign-in method.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'email-already-in-use':
        return 'That email already has an account. Sign in instead.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return error.message?.trim().isNotEmpty == true
            ? error.message!
            : 'Sign-in failed (${error.code}).';
    }
  }
  return error.toString();
}

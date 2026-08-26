import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:colette/config/site_config.dart';
import 'package:colette/services/auth_errors.dart';

void main() {
  test('unauthorized-domain names the custom host and console path', () {
    final message = describeAuthError(
      FirebaseAuthException(
        code: 'unauthorized-domain',
        message:
            'This domain is not authorized for OAuth operations for your Firebase project.',
      ),
    );

    expect(message, contains(SiteConfig.customDomain));
    expect(message, contains(SiteConfig.customDomainWww));
    expect(message, contains('Authorized domains'));
    expect(message, isNot(contains('firebase_auth/')));
  });

  test('popup closed is a short cancellation message', () {
    expect(
      describeAuthError(FirebaseAuthException(code: 'popup-closed-by-user')),
      'Sign-in was cancelled.',
    );
  });
}

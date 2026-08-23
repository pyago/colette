// Generated for Firebase project colette-memorial.
// Re-run `flutterfire configure --project=colette-memorial` if apps change.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.iOS:
      case TargetPlatform.android:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions are only configured for web in this project.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCfrCgihdjYH4mmbdvxL6XpabgZUDo6jpA',
    appId: '1:98026882793:web:db97c217e77d8880089278',
    messagingSenderId: '98026882793',
    projectId: 'colette-memorial',
    // Keep the Firebase Auth handler host. Custom Namecheap domains are added
    // under Authentication → Authorized domains; do not point authDomain at
    // Namecheap until that domain is Connected on Hosting.
    authDomain: 'colette-memorial.firebaseapp.com',
    storageBucket: 'colette-memorial.firebasestorage.app',
  );
}

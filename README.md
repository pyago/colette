# Colette — memorial web app

Flutter web memorial for **Collete Marie Williams**, with a public memory library,
user story submissions, and an admin console for Kwai.

## Local preview (no Firebase yet)

```bash
cd /Users/pyago/Projects/paiego/colette
flutter run -d chrome
# or: flutter run -d macos
```

In preview mode:

- Memorial splash matches `docs/Collete_Marie_Williams_Memorial_Updated.html`
- Email register/sign-in works locally (in-memory)
- Use **Preview as admin (local)** on the Sign in page, or sign in as `paul.yago@gmail.com`
- Social providers stay disabled until Firebase Auth is configured

## Admins

Configured in `lib/config/admin_config.dart`:

- `paul.yago@gmail.com`
- `kibawaF1990@gmail.com` (Kwai — owner)

## Enable Firebase

1. Create a Firebase project (Blaze only needed if you exceed free Storage/egress later).
2. Enable **Authentication** providers:
   - Email/Password
   - Google
   - Facebook
   - GitHub
   - Apple (needs Apple Developer + domain verify)
3. Create **Firestore** + **Storage**.
4. From this folder:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

5. Set `FirebaseConfig.enabled = true` in `lib/config/firebase_config.dart`.

### Suggested Firestore rules (tighten later)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAdmin() {
      return request.auth != null &&
        request.auth.token.email.lower() in
          ['paul.yago@gmail.com', 'kibawaf1990@gmail.com'];
    }
    match /posts/{id} {
      allow read: if resource.data.status == 'approved' || isAdmin()
        || (request.auth != null && resource.data.authorId == request.auth.uid);
      allow create: if request.auth != null
        && request.resource.data.authorId == request.auth.uid
        && request.resource.data.status == 'pending';
      allow update, delete: if isAdmin();
    }
  }
}
```

## Deploy + Porkbun domain

1. Build:

```bash
flutter build web --release
firebase init hosting   # public directory: build/web
firebase deploy --only hosting
```

2. In Firebase Hosting, add your custom domain.
3. At Porkbun, add the DNS records Firebase shows (usually A/AAAA or CNAME).
4. Wait for SSL provisioning.

## Product flow

| Role | Can do |
|------|--------|
| Visitor | Memorial splash, approved memories |
| Signed-in user | Submit story (pending review) |
| Admin | Approve/reject, publish own posts, thank/reply (opens mailto) |

Media upload via Firebase Storage is stubbed as URL fields for now; next step after Auth/Firestore is live.

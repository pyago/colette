# Colette — memorial web app

Flutter web memorial for **Collete Marie Williams**, with a public memory library,
user story submissions, and an admin console for Kwai.

**Backend:** Firebase Auth + Cloud Firestore (+ Storage when billing is enabled).

| Role | Can do |
|------|--------|
| Visitor | Memorial splash, approved memories (no sign-in) |
| Signed-in user | Submit story / image / video URL (pending review) |
| Admin | Approve/reject, publish own posts, thank/reply (mailto) |

Admins (see `lib/config/admin_config.dart`):

- `paul.yago@gmail.com`
- `kibawaF1990@gmail.com` (Kwai — owner)

## Firebase project

| | |
|--|--|
| Project | [colette-memorial](https://console.firebase.google.com/project/colette-memorial/overview) |
| Web app | Colette Web |
| Config | `lib/firebase_options.dart` (filled in) |
| Live mode switch | `FirebaseConfig.enabled` in `lib/config/firebase_config.dart` |

### Finish Auth in the console (required once)

Firebase Auth must be started in the console before email/OAuth work:

1. Open [Authentication → Get started](https://console.firebase.google.com/project/colette-memorial/authentication)
2. Enable providers:
   - **Email/Password**
   - **Google**
   - **Facebook** (needs Facebook app ID + secret)
   - **GitHub** (needs GitHub OAuth app client ID + secret)
   - **Apple** (needs Apple Developer + domain verify)
3. Under Authentication → Settings → Authorized domains, keep `localhost` and add your custom domain when you deploy.
4. Set `FirebaseConfig.enabled = true` and restart the app.

### Deploy rules / indexes

```bash
cd /Users/pyago/Projects/paiego/colette
firebase deploy --only firestore --project colette-memorial
# After Storage is created (Blaze billing required for uploads):
# firebase deploy --only storage --project colette-memorial
```

Media is still **URL fields** for now. Direct file upload needs Firebase Storage, which requires linking a billing account on this project.

## Local preview (Firebase off)

```bash
cd /Users/pyago/Projects/paiego/colette
flutter run -d chrome
```

With `FirebaseConfig.enabled = false`:

- Email register/sign-in is in-memory
- Use **Preview as admin (local)** on Sign in, or sign in as `paul.yago@gmail.com`
- Social providers stay disabled

## Local preview (Firebase on)

After Auth providers are enabled in the console:

1. Set `FirebaseConfig.enabled = true`
2. `flutter run -d chrome`
3. Register with email/password or a social provider
4. Share a story → it lands in Firestore as `pending`
5. Sign in as an admin email → `/admin` to approve

## Deploy hosting + Porkbun domain

```bash
flutter build web --release
firebase deploy --only hosting --project colette-memorial
```

Then add the custom domain in Firebase Hosting and the DNS records Porkbun shows.

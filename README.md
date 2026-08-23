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
3. Under Authentication → Settings → Authorized domains, keep `localhost` and `colette-memorial.firebaseapp.com`, then add the Namecheap domain (apex and `www`) after DNS is connected.
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

## Deploy hosting + Namecheap domain

Firebase URLs (already live):

| | |
|--|--|
| Hosting | https://colette-memorial.web.app |
| Auth / fallback | https://colette-memorial.firebaseapp.com |

Point the Namecheap domain at those hosts. Do **not** use Namecheap URL Redirect / forwarding — that only 302s to `.web.app` and breaks HTTPS + Google sign-in. Use Firebase Hosting custom domain + DNS A records.

### 1. Deploy the site

```bash
flutter build web --release
firebase deploy --only hosting --project colette-memorial
```

### 2. Attach the domain in Firebase

1. Open [Hosting](https://console.firebase.google.com/project/colette-memorial/hosting)
2. **Add custom domain** → enter the apex Namecheap domain (example: `yourdomain.com`)
3. Check **redirect `www` to the apex** (or the reverse, if you prefer `www` as canonical)
4. Copy the TXT verification value Firebase shows

### 3. Namecheap Advanced DNS

Namecheap → domain → **Advanced DNS**. Delete the stock **URL Redirect** and parking **CNAME** records (they conflict). Keep nameservers on Namecheap BasicDNS.

Add exactly what Firebase shows. For Namecheap the Host field is `@` or `www`, not the full domain:

| Type | Host | Value | TTL |
|------|------|--------|-----|
| TXT | `@` | the verification string from the Firebase wizard | Automatic |
| A | `@` | `199.36.158.100` (confirm in the wizard) | Automatic |
| A | `www` | `199.36.158.100` (confirm in the wizard) | Automatic |

If the wizard also lists AAAA records, add those too. Do not CNAME the apex to `colette-memorial.web.app` — Namecheap cannot CNAME `@`.

Wait until Firebase Hosting status is **Connected** (SSL can take up to a few hours). Check with:

```bash
./scripts/verify-namecheap-dns.sh yourdomain.com
```

### 4. Auth so Google sign-in returns to this domain

Firebase Auth still uses `authDomain: colette-memorial.firebaseapp.com` in `lib/firebase_options.dart` (leave it). After the custom domain is Connected:

1. [Authentication → Settings → Authorized domains](https://console.firebase.google.com/project/colette-memorial/authentication/settings) → add `yourdomain.com` and `www.yourdomain.com`
2. [Google Cloud credentials](https://console.cloud.google.com/apis/credentials?project=colette-memorial) → the **Web** OAuth 2.0 client:
   - Authorized JavaScript origins: `https://yourdomain.com`, `https://www.yourdomain.com`, `https://colette-memorial.web.app`, `https://colette-memorial.firebaseapp.com`
   - Authorized redirect URIs: keep `https://colette-memorial.firebaseapp.com/__/auth/handler` (and add `https://yourdomain.com/__/auth/handler` only if you later change `authDomain`)

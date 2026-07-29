import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/firebase_config.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/journal_page.dart';

class MemorialHomePage extends StatelessWidget {
  const MemorialHomePage({super.key, required this.auth});

  final AuthService auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _ScrapbookBackdrop(),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                children: [
                  if (!FirebaseConfig.enabled)
                    JournalPage(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Local preview mode — Firebase is not configured yet. '
                        'Email sign-in works locally; social providers need setup.',
                        style: GoogleFonts.caveat(
                          fontSize: 20,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                  _TopBar(auth: auth),
                  const SizedBox(height: 8),
                  const _HeroTitle(),
                  const SizedBox(height: 18),
                  JournalPage(
                    lilyCorner: LilyCorner.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Our Precious Angel',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.caveat(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Collete Marie Williams was born on August 5, 2025, '
                          'and passed peacefully on August 6, 2025. Though her '
                          'time on earth was brief, her life was filled with '
                          'immeasurable love and she left an everlasting imprint '
                          'on the hearts of her family and all who cherish her '
                          'memory.',
                          style: GoogleFonts.caveat(
                            fontSize: 24,
                            height: 1.35,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'She will forever be remembered as a precious gift '
                          'whose light continues to shine through the love, '
                          'hope, and memories she inspired.',
                          style: GoogleFonts.caveat(
                            fontSize: 24,
                            height: 1.35,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  JournalPage(
                    child: Text(
                      '"Some people only stay a moment, but their love lasts '
                      'a lifetime."',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.caveat(
                        fontSize: 28,
                        fontStyle: FontStyle.italic,
                        height: 1.35,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  JournalPage(
                    lilyCorner: LilyCorner.bottomRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Her Legacy',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.caveat(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Collete's memory lives on through the love of her "
                          'family, the dreams created in her honor, and the '
                          'lives touched by her story. This memorial serves as '
                          'a place of remembrance, reflection, and celebration '
                          'of her beautiful life.',
                          style: GoogleFonts.caveat(
                            fontSize: 24,
                            height: 1.35,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  JournalPage(
                    lilyCorner: LilyCorner.bottomRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Tributes & Memories',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.caveat(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Family and friends are invited to share photographs, '
                          'stories, prayers, and messages in honor of '
                          'Collete Marie Williams.',
                          style: GoogleFonts.caveat(
                            fontSize: 24,
                            height: 1.35,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            FilledButton.icon(
                              onPressed: () => context.go('/memories'),
                              icon: const Icon(Icons.favorite, size: 18),
                              label: const Text('View memories'),
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.accent,
                                side: const BorderSide(
                                  color: AppColors.accent,
                                  width: 1.4,
                                ),
                              ),
                              onPressed: () {
                                if (auth.isSignedIn) {
                                  context.go('/share');
                                } else {
                                  context.push('/auth');
                                }
                              },
                              child: const Text('Share a story'),
                            ),
                            if (auth.isAdmin)
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.accent,
                                  side: const BorderSide(
                                    color: AppColors.accent,
                                    width: 1.4,
                                  ),
                                ),
                                onPressed: () => context.go('/admin'),
                                child: const Text('Admin'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'In Loving Memory of Collete Marie Williams',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.caveat(
                      fontSize: 22,
                      color: AppColors.accentSoft,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'August 5, 2025 – August 6, 2025',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.caveat(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrapbookBackdrop extends StatelessWidget {
  const _ScrapbookBackdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.backgroundDeep,
            Color(0xFF1F102C),
          ],
        ),
      ),
      child: Opacity(
        opacity: 0.35,
        child: Image.asset(
          'assets/images/purple_bg.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.auth});

  final AuthService auth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(foregroundColor: AppColors.accentSoft),
        onPressed: () {
          if (auth.isSignedIn) {
            context.go('/share');
          } else {
            context.push('/auth');
          }
        },
        child: Text(
          auth.isSignedIn
              ? (auth.user?.displayName ?? auth.user?.email ?? 'Account')
              : 'Sign in',
        ),
      ),
    );
  }
}

class _HeroTitle extends StatelessWidget {
  const _HeroTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'In Loving Memory of Collete Marie Williams',
          textAlign: TextAlign.center,
          style: GoogleFonts.caveat(
            fontSize: 42,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'August 5, 2025 – August 6, 2025',
          textAlign: TextAlign.center,
          style: GoogleFonts.caveat(
            fontSize: 26,
            color: AppColors.accentSoft,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Forever Loved  ♥  Forever Remembered  ♥  Forever Missed',
          textAlign: TextAlign.center,
          style: GoogleFonts.caveat(
            fontSize: 22,
            color: AppColors.accentSoft,
          ),
        ),
      ],
    );
  }
}

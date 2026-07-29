import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/firebase_config.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/journal_page.dart';

enum _MemorialTheme { theme1, theme2, theme3 }

class MemorialHomePage extends StatefulWidget {
  const MemorialHomePage({super.key, required this.auth});

  final AuthService auth;

  @override
  State<MemorialHomePage> createState() => _MemorialHomePageState();
}

class _MemorialHomePageState extends State<MemorialHomePage> {
  _MemorialTheme _theme = _MemorialTheme.theme1;
  TextAlign _textAlign = TextAlign.left;

  Color get _ink => switch (_theme) {
    _MemorialTheme.theme1 => AppColors.ink,
    _MemorialTheme.theme2 => const Color(0xFF45364F),
    _MemorialTheme.theme3 => const Color(0xFF4D494D),
  };

  Color get _accent => switch (_theme) {
    _MemorialTheme.theme1 => AppColors.accent,
    _MemorialTheme.theme2 => const Color(0xFF76549A),
    _MemorialTheme.theme3 => const Color(0xFF8A5877),
  };

  Color get _lightText => switch (_theme) {
    _MemorialTheme.theme1 => AppColors.accentSoft,
    _MemorialTheme.theme2 => const Color(0xFF5D476C),
    _MemorialTheme.theme3 => const Color(0xFF5B565A),
  };

  TextStyle _font({
    required double size,
    Color? color,
    FontWeight? weight,
    FontStyle? style,
    double? height,
  }) {
    final arguments = TextStyle(
      fontSize: size,
      color: color ?? _ink,
      fontWeight: weight,
      fontStyle: style,
      height: height,
    );
    return switch (_theme) {
      _MemorialTheme.theme1 => GoogleFonts.caveat(textStyle: arguments),
      _MemorialTheme.theme2 => GoogleFonts.cormorantGaramond(
        textStyle: arguments,
      ),
      _MemorialTheme.theme3 => GoogleFonts.comingSoon(
        textStyle: arguments.copyWith(letterSpacing: 1.2),
      ),
    };
  }

  WrapAlignment get _wrapAlignment => switch (_textAlign) {
    TextAlign.center => WrapAlignment.center,
    TextAlign.right || TextAlign.end => WrapAlignment.end,
    _ => WrapAlignment.start,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _ThemedBackdrop(theme: _theme),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                children: [
                  _ControlHeader(
                    controls: _PageControls(
                      theme: _theme,
                      textAlign: _textAlign,
                      accent: _accent,
                      textStyle: _font(size: 16, weight: FontWeight.w600),
                      onThemeChanged: (theme) => setState(() => _theme = theme),
                      onTextAlignChanged: (alignment) =>
                          setState(() => _textAlign = alignment),
                    ),
                    account: _TopBar(
                      auth: widget.auth,
                      color: _lightText,
                      textStyle: _font(size: 20, weight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!FirebaseConfig.enabled)
                    _ThemedPage(
                      theme: _theme,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Local preview mode — Firebase is not configured yet. '
                        'Email sign-in works locally; social providers need setup.',
                        textAlign: _textAlign,
                        style: _font(size: 20, color: _lightText),
                      ),
                    ),
                  _HeroTitle(
                    theme: _theme,
                    textAlign: _textAlign,
                    titleStyle: _font(
                      size: 42,
                      color: _theme == _MemorialTheme.theme1
                          ? Colors.white
                          : _ink,
                      weight: FontWeight.w700,
                      height: 1.15,
                    ),
                    dateStyle: _font(size: 26, color: _lightText),
                    taglineStyle: _font(size: 22, color: _lightText),
                  ),
                  const SizedBox(height: 18),
                  _ThemedPage(
                    theme: _theme,
                    lilyCorner: LilyCorner.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Our Precious Angel',
                          textAlign: _textAlign,
                          style: _font(
                            size: 32,
                            weight: FontWeight.w700,
                            color: _accent,
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
                          textAlign: _textAlign,
                          style: _font(size: 24, height: 1.35),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'She will forever be remembered as a precious gift '
                          'whose light continues to shine through the love, '
                          'hope, and memories she inspired.',
                          textAlign: _textAlign,
                          style: _font(size: 24, height: 1.35),
                        ),
                      ],
                    ),
                  ),
                  _ThemedPage(
                    theme: _theme,
                    child: Text(
                      '"Some people only stay a moment, but their love lasts '
                      'a lifetime."',
                      textAlign: _textAlign,
                      style: _font(
                        size: 28,
                        style: FontStyle.italic,
                        height: 1.35,
                      ),
                    ),
                  ),
                  _ThemedPage(
                    theme: _theme,
                    lilyCorner: LilyCorner.bottomRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Her Legacy',
                          textAlign: _textAlign,
                          style: _font(
                            size: 32,
                            weight: FontWeight.w700,
                            color: _accent,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Collete's memory lives on through the love of her "
                          'family, the dreams created in her honor, and the '
                          'lives touched by her story. This memorial serves as '
                          'a place of remembrance, reflection, and celebration '
                          'of her beautiful life.',
                          textAlign: _textAlign,
                          style: _font(size: 24, height: 1.35),
                        ),
                      ],
                    ),
                  ),
                  _ThemedPage(
                    theme: _theme,
                    lilyCorner: LilyCorner.bottomRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Tributes & Memories',
                          textAlign: _textAlign,
                          style: _font(
                            size: 32,
                            weight: FontWeight.w700,
                            color: _accent,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Family and friends are invited to share photographs, '
                          'stories, prayers, and messages in honor of '
                          'Collete Marie Williams.',
                          textAlign: _textAlign,
                          style: _font(size: 24, height: 1.35),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          alignment: _wrapAlignment,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: _accent,
                                foregroundColor: Colors.white,
                                textStyle: _font(
                                  size: 20,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () => context.go('/memories'),
                              icon: const Icon(Icons.favorite, size: 18),
                              label: const Text('View memories'),
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _accent,
                                textStyle: _font(
                                  size: 20,
                                  weight: FontWeight.w600,
                                ),
                                side: BorderSide(color: _accent, width: 1.4),
                              ),
                              onPressed: () {
                                if (widget.auth.isSignedIn) {
                                  context.go('/share');
                                } else {
                                  context.push('/auth');
                                }
                              },
                              child: const Text('Share a story'),
                            ),
                            if (widget.auth.isAdmin)
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _accent,
                                  textStyle: _font(
                                    size: 20,
                                    weight: FontWeight.w600,
                                  ),
                                  side: BorderSide(color: _accent, width: 1.4),
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
                    textAlign: _textAlign,
                    style: _font(size: 22, color: _lightText),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'August 5, 2025 – August 6, 2025',
                    textAlign: _textAlign,
                    style: _font(size: 20, color: _lightText),
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

class _ThemedPage extends StatelessWidget {
  const _ThemedPage({
    required this.theme,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 22, 22, 22),
    this.lilyCorner = LilyCorner.none,
  });

  final _MemorialTheme theme;
  final Widget child;
  final EdgeInsets padding;
  final LilyCorner lilyCorner;

  @override
  Widget build(BuildContext context) {
    if (theme == _MemorialTheme.theme1) {
      return JournalPage(
        padding: padding,
        lilyCorner: lilyCorner,
        child: child,
      );
    }

    final isFloral = theme == _MemorialTheme.theme2;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isFloral ? const Color(0xEFFFFFFF) : const Color(0xEDEBEAEB),
        borderRadius: BorderRadius.circular(isFloral ? 22 : 6),
        border: Border.all(
          color: isFloral ? const Color(0x55A88AC0) : const Color(0x665A555A),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isFloral ? 0.10 : 0.06),
            blurRadius: isFloral ? 22 : 8,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (lilyCorner != LilyCorner.none)
            Positioned(
              top: lilyCorner == LilyCorner.topLeft ? -8 : null,
              left: lilyCorner == LilyCorner.topLeft ? -18 : null,
              right: lilyCorner == LilyCorner.bottomRight ? -18 : null,
              bottom: lilyCorner == LilyCorner.bottomRight ? -16 : null,
              child: Opacity(
                opacity: isFloral ? 0.30 : 0.22,
                child: Image.asset(
                  isFloral
                      ? 'assets/images/theme_2_flowers.png'
                      : 'assets/images/theme_3_flowers.png',
                  width: isFloral ? 250 : 190,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ),
          Padding(
            padding: padding.copyWith(left: padding.left + 8),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _ThemedBackdrop extends StatelessWidget {
  const _ThemedBackdrop({required this.theme});

  final _MemorialTheme theme;

  @override
  Widget build(BuildContext context) {
    final (background, asset, opacity, alignment) = switch (theme) {
      _MemorialTheme.theme1 => (
        const Color(0xFF33203F),
        'assets/images/theme_1.jpg',
        0.22,
        Alignment.center,
      ),
      _MemorialTheme.theme2 => (
        const Color(0xFFF5EFF9),
        'assets/images/theme_2.jpeg',
        0.92,
        Alignment.bottomCenter,
      ),
      _MemorialTheme.theme3 => (
        const Color(0xFFD9D8DC),
        'assets/images/theme_3.jpg',
        0.22,
        Alignment.bottomRight,
      ),
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      child: ColoredBox(
        key: ValueKey(theme),
        color: background,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
              opacity: opacity,
              child: Image.asset(
                asset,
                fit: BoxFit.cover,
                alignment: alignment,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: switch (theme) {
                  _MemorialTheme.theme1 => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x553F2850), Color(0xAA1F102C)],
                  ),
                  _MemorialTheme.theme2 => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x44FFFFFF), Color(0x11FFFFFF)],
                  ),
                  _MemorialTheme.theme3 => const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0x55FFFFFF), Color(0x118A7F88)],
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlHeader extends StatelessWidget {
  const _ControlHeader({required this.controls, required this.account});

  final Widget controls;
  final Widget account;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controls,
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerRight, child: account),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: controls),
            const SizedBox(width: 12),
            account,
          ],
        );
      },
    );
  }
}

class _PageControls extends StatelessWidget {
  const _PageControls({
    required this.theme,
    required this.textAlign,
    required this.accent,
    required this.textStyle,
    required this.onThemeChanged,
    required this.onTextAlignChanged,
  });

  final _MemorialTheme theme;
  final TextAlign textAlign;
  final Color accent;
  final TextStyle textStyle;
  final ValueChanged<_MemorialTheme> onThemeChanged;
  final ValueChanged<TextAlign> onTextAlignChanged;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      visualDensity: VisualDensity.compact,
      textStyle: WidgetStatePropertyAll(textStyle),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? Colors.white : accent,
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? accent
            : Colors.white.withValues(alpha: 0.88),
      ),
      side: WidgetStatePropertyAll(BorderSide(color: accent)),
    );

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        SegmentedButton<_MemorialTheme>(
          style: style,
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: _MemorialTheme.theme1, label: Text('Theme 1')),
            ButtonSegment(value: _MemorialTheme.theme2, label: Text('Theme 2')),
            ButtonSegment(value: _MemorialTheme.theme3, label: Text('Theme 3')),
          ],
          selected: {theme},
          onSelectionChanged: (selection) => onThemeChanged(selection.single),
        ),
        SegmentedButton<TextAlign>(
          style: style,
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(
              value: TextAlign.left,
              icon: Icon(Icons.format_align_left),
              label: Text('Left'),
            ),
            ButtonSegment(
              value: TextAlign.center,
              icon: Icon(Icons.format_align_center),
              label: Text('Center'),
            ),
            ButtonSegment(
              value: TextAlign.right,
              icon: Icon(Icons.format_align_right),
              label: Text('Right'),
            ),
          ],
          selected: {textAlign},
          onSelectionChanged: (selection) =>
              onTextAlignChanged(selection.single),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.auth,
    required this.color,
    required this.textStyle,
  });

  final AuthService auth;
  final Color color;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: color,
        backgroundColor: Colors.white.withValues(alpha: 0.16),
        textStyle: textStyle,
      ),
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
    );
  }
}

class _HeroTitle extends StatelessWidget {
  const _HeroTitle({
    required this.theme,
    required this.textAlign,
    required this.titleStyle,
    required this.dateStyle,
    required this.taglineStyle,
  });

  final _MemorialTheme theme;
  final TextAlign textAlign;
  final TextStyle titleStyle;
  final TextStyle dateStyle;
  final TextStyle taglineStyle;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: theme == _MemorialTheme.theme1
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: theme == _MemorialTheme.theme1
          ? null
          : BoxDecoration(
              color: Colors.white.withValues(
                alpha: theme == _MemorialTheme.theme2 ? 0.62 : 0.42,
              ),
              borderRadius: BorderRadius.circular(
                theme == _MemorialTheme.theme2 ? 26 : 6,
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'In Loving Memory of Collete Marie Williams',
            textAlign: textAlign,
            style: titleStyle,
          ),
          const SizedBox(height: 10),
          Text(
            'August 5, 2025 – August 6, 2025',
            textAlign: textAlign,
            style: dateStyle,
          ),
          const SizedBox(height: 8),
          Text(
            'Forever Loved  ♥  Forever Remembered  ♥  Forever Missed',
            textAlign: textAlign,
            style: taglineStyle,
          ),
        ],
      ),
    );
  }
}

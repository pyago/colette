import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum LilyCorner { none, topLeft, bottomRight }

/// Lined notebook page with spiral binding and optional lily accent.
class JournalPage extends StatelessWidget {
  const JournalPage({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 22, 22, 22),
    this.lilyCorner = LilyCorner.none,
  });

  final Widget child;
  final EdgeInsets padding;
  final LilyCorner lilyCorner;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _LinedPaperPainter()),
            ),
            if (lilyCorner != LilyCorner.none)
              Positioned(
                top: lilyCorner == LilyCorner.topLeft ? -10 : null,
                left: lilyCorner == LilyCorner.topLeft ? 8 : null,
                right: lilyCorner == LilyCorner.bottomRight ? -6 : null,
                bottom: lilyCorner == LilyCorner.bottomRight ? -8 : null,
                child: Opacity(
                  opacity: 0.55,
                  child: Image.asset(
                    'assets/images/purple_lily.png',
                    width: 120,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),
              ),
            Padding(
              padding: padding.copyWith(left: padding.left + 28),
              child: child,
            ),
            const Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 28,
              child: CustomPaint(painter: _SpiralBindingPainter()),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinedPaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final wash = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0x33C9A7E0),
          Color(0x00FFFFFF),
          Color(0x22B07CC8),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, wash);

    final linePaint = Paint()
      ..color = AppColors.paperLine.withValues(alpha: 0.55)
      ..strokeWidth = 1;
    const spacing = 28.0;
    for (double y = spacing; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final margin = Paint()
      ..color = const Color(0x55E8A0A0)
      ..strokeWidth = 1.2;
    canvas.drawLine(
      const Offset(36, 0),
      Offset(36, size.height),
      margin,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SpiralBindingPainter extends CustomPainter {
  const _SpiralBindingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final ring = Paint()
      ..color = const Color(0xFF9A9AA8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    final fill = Paint()..color = const Color(0xFFD8D8E0);
    const step = 26.0;
    for (double y = 14; y < size.height - 8; y += step) {
      final rect = Rect.fromCenter(
        center: Offset(size.width * 0.55, y),
        width: 16,
        height: 14,
      );
      canvas.drawOval(rect, fill);
      canvas.drawOval(rect, ring);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.ink,
    required this.ink2,
    required this.ink3,
    required this.line,
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
    required this.ok,
    required this.warn,
    required this.bad,
    required this.badSoft,
    required this.nav,
    required this.navActive,
    required this.scrim,
  });

  final Color bg;
  final Color surface;
  final Color surface2;
  final Color ink;
  final Color ink2;
  final Color ink3;
  final Color line;
  final Color accent;
  final Color accentSoft;
  final Color onAccent;
  final Color ok;
  final Color warn;
  final Color bad;
  final Color badSoft;
  final Color nav;
  final Color navActive;
  final Color scrim;

  static const AppColors light = AppColors(
    bg: Color(0xFFEFEBDF),
    surface: Color(0xFFFAF7EF),
    surface2: Color(0xFFE4DFCF),
    ink: Color(0xFF1E2620),
    ink2: Color(0xFF5E655C),
    ink3: Color(0xFF8F9488),
    line: Color.fromARGB(23, 30, 38, 32),
    accent: Color(0xFF4A6B55),
    accentSoft: Color(0xFFD8E2D2),
    onAccent: Color(0xFFFAF7EF),
    ok: Color(0xFF55806A),
    warn: Color(0xFFA37F3E),
    bad: Color(0xFFA35B45),
    badSoft: Color(0xFFF2E1DB),
    nav: Color.fromARGB(209, 250, 247, 239),
    navActive: Color(0xFFD8E2D2),
    scrim: Color.fromARGB(82, 30, 38, 32),
  );

  static const AppColors dark = AppColors(
    bg: Color(0xFF26282B),
    surface: Color(0xFF383B40),
    surface2: Color(0xFF46494F),
    ink: Color(0xFFECEDEF),
    ink2: Color(0xFFB0B3B8),
    ink3: Color(0xFF7B7F86),
    line: Color.fromARGB(26, 236, 237, 239),
    accent: Color(0xFFA9C4AF),
    accentSoft: Color(0xFF44564A),
    onAccent: Color(0xFF212326),
    ok: Color(0xFF93C1A0),
    warn: Color(0xFFD8B777),
    bad: Color(0xFFD8937E),
    badSoft: Color(0xFF4A3A36),
    nav: Color.fromARGB(215, 56, 59, 64),
    navActive: Color(0xFF4C5056),
    scrim: Color.fromARGB(128, 0, 0, 0),
  );

  @override
  AppColors copyWith({
    Color? bg,
    Color? surface,
    Color? surface2,
    Color? ink,
    Color? ink2,
    Color? ink3,
    Color? line,
    Color? accent,
    Color? accentSoft,
    Color? onAccent,
    Color? ok,
    Color? warn,
    Color? bad,
    Color? badSoft,
    Color? nav,
    Color? navActive,
    Color? scrim,
  }) {
    return AppColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      ink: ink ?? this.ink,
      ink2: ink2 ?? this.ink2,
      ink3: ink3 ?? this.ink3,
      line: line ?? this.line,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      onAccent: onAccent ?? this.onAccent,
      ok: ok ?? this.ok,
      warn: warn ?? this.warn,
      bad: bad ?? this.bad,
      badSoft: badSoft ?? this.badSoft,
      nav: nav ?? this.nav,
      navActive: navActive ?? this.navActive,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    // Tokens semánticos: snapean, no interpolan. Así se cambia de tema de golpe.
    return t < 0.5 ? this : (other ?? this);
  }
}

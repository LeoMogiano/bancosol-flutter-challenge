import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';

class ProductAvatar extends StatelessWidget {
  const ProductAvatar({required this.product, this.size = 44, super.key});

  final Product product;
  final double size;

  static const List<Color> _lightTints = [
    Color(0xFFD5E3D3),
    Color(0xFFE8DFC9),
    Color(0xFFD1E1E3),
    Color(0xFFEBD9CD),
    Color(0xFFDDE3CB),
  ];

  static const List<Color> _darkTints = [
    Color(0xFF4B5C4F),
    Color(0xFF5D5644),
    Color(0xFF475A5E),
    Color(0xFF61504A),
    Color(0xFF545A45),
  ];

  static final RegExp _spaces = RegExp(r'\s+');

  String _initials() {
    final name = product.name.trim();
    if (name.isEmpty) return '?';
    return name.split(_spaces).take(2).map((word) => word[0]).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    final tints = isDarkMode ? _darkTints : _lightTints;
    final tintIndex = product.id % 5;
    final backgroundColor = tints[tintIndex];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(size * 0.3)),
      child: Center(
        child: Text(
          _initials(),
          style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.w600, color: context.colors.ink),
        ),
      ),
    );
  }
}

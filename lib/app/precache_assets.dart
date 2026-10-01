import 'dart:async';

import 'package:flutter/material.dart';
import 'package:warehouse/core/constants/app_assets.dart';

class PrecacheAssets extends StatefulWidget {
  const PrecacheAssets({required this.child, super.key});

  final Widget child;

  @override
  State<PrecacheAssets> createState() => _PrecacheAssetsState();
}

class _PrecacheAssetsState extends State<PrecacheAssets> {
  bool _cached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_cached) {
      unawaited(precacheImage(const AssetImage(AppAssets.logo), context));
      _cached = true;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

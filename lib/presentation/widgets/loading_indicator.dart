// lib/presentation/widgets/loading_indicator.dart
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;

  const LoadingIndicator({
    super.key,
    this.size = 36.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SpinKitFadingCircle(
      color: theme.colorScheme.primary,
      size: size,
    );
  }
}
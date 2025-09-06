import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../provider/common/loading_provider.dart';

class LoadingProgress extends StatelessWidget {
  final Widget child;
  const LoadingProgress({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        child,
        Selector<LoadingProvider, bool>(
          selector: (_, p) => p.isLoading,
          builder: (context, isLoading, _) {
            if (!isLoading) return const SizedBox.shrink();
            return Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: SpinKitFadingCircle(
                    color: Colors.blueAccent,
                    size: (screenW * 0.15).clamp(32.0, 72.0),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}


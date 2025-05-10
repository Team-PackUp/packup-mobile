import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/common/loading_provider.dart';

class LoadingProgress extends StatelessWidget {
  final Widget child;

  const LoadingProgress({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Consumer<LoadingProvider>(
          builder: (context, notifier, _) {
            if (notifier.isLoading) {
              return Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              );
            } else {
              return const SizedBox.shrink(); // < 이거는 아무것도 표시 하지 않는? 위젯인듯
            }
          },
        ),
      ],
    );
  }
}


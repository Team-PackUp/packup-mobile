import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomError extends StatelessWidget {
  final String message;
  const CustomError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 72, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenH * 0.02),
            SizedBox(
              width: screenH,
              child: ElevatedButton(
                onPressed: () {
                  if (GoRouter.of(context).canPop()) {
                    GoRouter.of(context).pop();
                  } else {
                    context.go('/index');
                  }
                },
                child: const Text('확인'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

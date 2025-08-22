import 'package:flutter/cupertino.dart';

import '../reply_card.dart';
import '../reply_intro_card.dart';

class ReplyGreetingSection extends StatelessWidget {
  const ReplyGreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReplyCard(child: ReplyIntroCard()),
      ],
    );
  }
}
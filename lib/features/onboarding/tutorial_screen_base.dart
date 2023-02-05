import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constant/gaps.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';

class TutorialScreenBase extends StatelessWidget {
  const TutorialScreenBase({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gaps.v60,
        Text(
          title,
          style: const TextStyle(
            fontSize: Sizes.size36,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gaps.v16,
        const Text(
          "Videos are personalized for you based on what you watch, like, and share.",
          style: TextStyle(
            fontSize: Sizes.size18,
          ),
        ),
      ],
    );
  }
}

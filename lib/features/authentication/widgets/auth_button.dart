import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final FaIcon icon;

  const AuthButton({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: Sizes.size1,
      child: Container(
        padding: const EdgeInsets.all(Sizes.size14),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            width: Sizes.size1,
          ),
        ),
        child: Stack(
          // Row, Column 과 다르게 Stack 은 쌓는 개념
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: icon,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: Sizes.size16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

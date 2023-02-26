import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constant/gaps.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';

class UserProfileInformation extends StatelessWidget {
  const UserProfileInformation({
    Key? key,
    required this.data,
    required this.information,
  }) : super(key: key);

  final int data;
  final String information;

  String numberToString(int num) {
    // TODO 숫자가 들어오면 K, M 으로 표현해줌
    return num.toString() + "M";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          numberToString(data),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.size18,
          ),
        ),
        Gaps.v3,
        Text(
          information,
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}

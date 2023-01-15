import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constant/gaps.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';
import 'package:flutter_tiktok_clone/features/authentication/login_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/widgets/auth_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  void onLoginTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Status Bar 를 피해서 만들 수 있음
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size40,
          ),
          child: Column(
            children: const [
              Gaps.v80,
              Text(
                "Sign up for Tiktok",
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v20,
              Text(
                "Create a profile, follow other accounts, make your own videos, and more.",
                style: TextStyle(
                  fontSize: Sizes.size16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.v40,
              AuthButton(
                text: "Use phone or email",
                icon: FaIcon(FontAwesomeIcons.user),
              ),
              Gaps.v16,
              AuthButton(
                text: "Continue with Apple",
                icon: FaIcon(FontAwesomeIcons.apple),
              ),
              Gaps.v16,
              AuthButton(
                text: "Continue with Google",
                icon: FaIcon(FontAwesomeIcons.google),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.shade200,
        elevation: Sizes.size1,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.size32,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account?",
              ),
              Gaps.h5,
              GestureDetector(
                onTap: () => onLoginTap(context),
                child: Text(
                  " Log in",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

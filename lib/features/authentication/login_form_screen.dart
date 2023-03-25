import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constant/gaps.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';
import 'package:flutter_tiktok_clone/features/authentication/widgets/form_button.dart';
import 'package:flutter_tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:go_router/go_router.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({Key? key}) : super(key: key);

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        // Validator 를 동작시킴
        _formKey.currentState!.save();
        // Navigator.of(context).pushAndRemoveUntil(
        // Navigator.of(context).push 의 의미는 다른 화면들의 맨 위에 새로운걸 밀어넣는 것 => 유저가 원하면 뒤로 돌아갈 수 있음
        // MaterialPageRoute(
        //   builder: (context) => const InterestsScreen(),
        // ),
        // (route) => false, // 이전의 route 정보를 유지할 것인가 말것인가를 bool 로 전달
        // );
        context.goNamed(InterestsScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log in"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size36,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Gaps.v28,
              TextFormField(
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  hintText: "Email",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Please write your email.";
                  }
                  return null;
                },
                onSaved: (newValue) => {
                  if (newValue != null)
                    {formData['email'] = newValue.replaceAll(" ", "")}
                },
              ),
              Gaps.v16,
              TextFormField(
                cursorColor: Theme.of(context).primaryColor,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                validator: (value) {
                  // TODO validation rule 작성
                  if (value != null && value.isEmpty) {
                    return "Please check password";
                  }
                  return null;
                },
                onSaved: (newValue) => {
                  if (newValue != null)
                    {formData['password'] = newValue.replaceAll(" ", "")}
                },
              ),
              Gaps.v28,
              GestureDetector(
                onTap: _onSubmitTap,
                child: const FormButton(disabled: false, buttonText: "Next"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

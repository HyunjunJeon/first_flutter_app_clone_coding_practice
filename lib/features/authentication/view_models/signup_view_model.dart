import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:flutter_tiktok_clone/utils.dart';
import 'package:go_router/go_router.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepository;

  @override
  FutureOr<void> build() {
    _authRepository = ref.read(autoRepo);
  }

  Future<void> signUp(BuildContext context) async {
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);
    state = await AsyncValue.guard(
      () async => await _authRepository.emailSignUp(
        form["email"],
        form["password"],
      ),
    );
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.goNamed(InterestsScreen.routeName);
    }
  }
}

final signUpForm = StateProvider((ref) => {});
final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);

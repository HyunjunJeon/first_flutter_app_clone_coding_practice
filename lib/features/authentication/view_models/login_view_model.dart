import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/utils.dart';
import 'package:go_router/go_router.dart';

class LoginViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(autoRepo);
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => await _repository.emailSignIn(
        email,
        password,
      ),
    );
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.go("/home");
    }
  }
}

final loginProvider = AsyncNotifierProvider<LoginViewModel, void>(
  () => LoginViewModel(),
);

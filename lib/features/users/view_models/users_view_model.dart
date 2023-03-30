import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:flutter_tiktok_clone/features/users/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _userRepository;
  late final AuthenticationRepository _authRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    // await Future.delayed(const Duration(seconds: 5)); // 실제로 동작하는지 테스트용도

    _userRepository = ref.read(userRepo);
    _authRepository = ref.read(autoRepo);

    if (_authRepository.isLoggedIn) {
      final profile =
          await _userRepository.findProfile(_authRepository.user!.uid);
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }

    return UserProfileModel.empty();
  }

  Future<void> createAccount(
      UserCredential credential, Map<dynamic, dynamic> form) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }
    state = const AsyncValue.loading();
    final profile = UserProfileModel(
      hasAvatar: false,
      bio: form["bio"],
      link: credential.user!.photoURL ?? "noLink",
      uid: credential.user!.uid,
      name: form["displayName"] ?? credential.user!.displayName ?? "Anon",
      email: credential.user!.email ?? "anon@anon.com",
    );
    await _userRepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    await _userRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';
import 'package:flutter_tiktok_clone/features/users/view_models/avatar_view_model.dart';
import 'package:image_picker/image_picker.dart';

class Avatar extends ConsumerWidget {
  final String name;
  final String uid;
  final bool hasAvatar;

  const Avatar({
    Key? key,
    required this.name,
    required this.hasAvatar,
    required this.uid,
  }) : super(key: key);

  Future<void> _onAvatarTap(WidgetRef ref) async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
      maxHeight: 150,
    );
    if (xFile != null) {
      final imageFile = File(xFile.path);
      ref.read(avatarProvider.notifier).uploadAvatar(imageFile);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    return GestureDetector(
      onTapUp: isLoading ? null : (details) => _onAvatarTap(ref),
      child: isLoading
          ? Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator.adaptive(),
            )
          : CircleAvatar(
              radius: Sizes.size52,
              foregroundColor: Colors.teal,
              foregroundImage: hasAvatar ? NetworkImage("""
https://firebasestorage.googleapis.com/v0/b/jhj-flutter-first.appspot.com/o/avatars%2F$uid?alt=media&haha=${DateTime.now().toString()}
""") : null,
              child: Text(name),
            ),
    );
  }
}

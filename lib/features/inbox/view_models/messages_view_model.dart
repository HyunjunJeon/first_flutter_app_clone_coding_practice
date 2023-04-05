import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/inbox/models/message.dart';
import 'package:flutter_tiktok_clone/features/inbox/repos/messages_repo.dart';

class MessagesViewModel extends AsyncNotifier<void> {
  late final MessagesRepo _messagesRepo;

  @override
  FutureOr<void> build() {
    _messagesRepo = ref.read(messagesRepo);
  }

  Future<void> sendMessage(String text) async {
    final userId = ref.read(authRepo).user!.uid;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: userId,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      _messagesRepo.sendMessage(message);
    });
  }
}

final messagesProvider = AsyncNotifierProvider<MessagesViewModel, void>(
  () => MessagesViewModel(),
);

final chatProvider = StreamProvider.autoDispose
    .family<List<MessageModel>, String>((ref, chatRoomId) {
  final _database = FirebaseFirestore.instance;
  print(chatRoomId);
  chatRoomId = "ZM9d6K3oc7Eat86xkzwA"; // TODO 자동 생성된 값을 나중에는 가져와서 입력해줘야함

  return _database
      .collection("chat_rooms")
      .doc(chatRoomId)
      .collection("text")
      .orderBy("createdAt")
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (doc) => MessageModel.fromJson(
                doc.data(),
              ),
            )
            .toList()
            .reversed
            .toList(),
      );
});

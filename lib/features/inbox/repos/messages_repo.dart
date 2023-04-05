import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/inbox/models/message.dart';

class MessagesRepo {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel message) async {
    await _database
        .collection("chat_rooms")
        .doc("ZM9d6K3oc7Eat86xkzwA") // TODO 자동 생성된 값을 나중에는 가져와서 입력해줘야함
        .collection("text")
        .add(message.toJson());
  }
}

final messagesRepo = Provider((ref) => MessagesRepo());

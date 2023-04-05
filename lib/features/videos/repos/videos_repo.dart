import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/videos/models/video_model.dart';

class VideosRepository {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef = _storage.ref().child(
        "/videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}");
    return fileRef.putFile(video);
  }

  Future<void> saveVideo(VideoModel videoModel) async {
    await _database.collection("videos").add(videoModel.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos({
    int? lastItemCreatedAt,
  }) {
    // return _database.collection("videos").where("likes", isGreaterThan: 10).get(); // 좋아요 개수가 10개 이상인 영상만 다 가져오게
    final query = _database
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .limit(2);
    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }

  Future<bool> toggleVideoLike(String videoId, String userId) async {
    final query = await _database.collection("likes").doc(
        "${videoId}000${userId}"); // Firestore Database 의 Search 를 효율적으로 하기 위해서
    final like = await query.get();
    if (!like.exists) {
      await query.set(
        {
          "createdAt": DateTime.now().millisecondsSinceEpoch,
        },
      );
      return true;
    } else {
      await query.delete();
      return false;
    }
  }

  Future<bool> isLikedVideo({
    required String videoId,
    required String userId,
  }) async {
    final like =
        await _database.collection("likes").doc("${videoId}000${userId}").get();
    return like.exists;
  }
}

final videosRepo = Provider((ref) => VideosRepository());

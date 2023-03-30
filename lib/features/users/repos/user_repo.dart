import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/users/models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> createProfile(UserProfileModel profile) async {
    await _database.collection("users").doc(profile.uid).set(profile.toJson());
  }

  // get profile
  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _database.collection("users").doc(uid).get();
    return doc.data();
  }

  Future<void> uploadAvatar(String fileName, File imageFile) async {
    final Reference fileRef = _storage.ref().child("avatars/$fileName");
    await fileRef.putFile(imageFile);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _database.collection("users").doc(uid).update(data);
  }
}

final userRepo = Provider((ref) => UserRepository());

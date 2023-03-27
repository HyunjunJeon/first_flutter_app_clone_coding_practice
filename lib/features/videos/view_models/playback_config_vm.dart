import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:flutter_tiktok_clone/features/videos/repositories/playback_config_repo.dart';

class PlaybackConfigViewModel extends ChangeNotifier {
  final PlaybackConfigRepository _repository;

  late final PlaybackConfigModel _model = PlaybackConfigModel(
    muted: _repository.isMuted(),
    autoplay: _repository.isAutoplay(),
  );

  PlaybackConfigViewModel(this._repository);

  void setMuted(bool value) async {
    await _repository.setMuted(value);
    _model.muted = value;
    notifyListeners();
  }

  void setAutoplay(bool value) async {
    await _repository.setAutoplay(value);
    _model.autoplay = value;
    notifyListeners();
  }

  bool get muted => _model.muted;
  bool get autoplay => _model.autoplay;
}

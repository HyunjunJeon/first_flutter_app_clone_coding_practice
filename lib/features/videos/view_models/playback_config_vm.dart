import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:flutter_tiktok_clone/features/videos/repositories/playback_config_repo.dart';

class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  final PlaybackConfigRepository _repository;

  PlaybackConfigViewModel(this._repository);

  // late final PlaybackConfigModel _model = PlaybackConfigModel(
  //   muted: _repository.isMuted(),
  //   autoplay: _repository.isAutoplay(),
  // );

  void setMuted(bool value) async {
    await _repository.setMuted(value);
    // Riverpod: state 를 항상 새로 생성해준다는 것(Mutable 객체이기 때문에)
    state = PlaybackConfigModel(
      muted: value,
      autoplay: state.autoplay,
    );
    // _model.muted = value; // Provider 용 코드
    // notifyListeners(); // Provider 용 코드
  }

  void setAutoplay(bool value) async {
    await _repository.setAutoplay(value);
    state = PlaybackConfigModel(
      muted: state.muted,
      autoplay: value,
    );
    // _model.autoplay = value; // Provider 용 코드
    // notifyListeners(); // Provider 용 코드
  }

  // bool get muted => _model.muted; // Provider 용 코드
  // bool get autoplay => _model.autoplay; // Provider 용 코드

  // View 쪽에서 원하는 Model 데이터의 초기 상태를 반환해야함
  @override
  PlaybackConfigModel build() {
    return PlaybackConfigModel(
      muted: _repository.isMuted(),
      autoplay: _repository.isAutoplay(),
    );
  }
}

// Main 에서 override 해서 repository 를 주입하기 위함
final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  () => throw UnimplementedError(),
);

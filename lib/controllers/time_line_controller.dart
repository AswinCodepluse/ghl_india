import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/repositories/time_line_repository.dart';

class TimeLineController extends GetxController {
  var activeTimeLineList = [].obs;
  var firstFollowupDate = "".obs;
  var firstOldStatus = "".obs;
  RxBool loadingState = false.obs;
  var leadId = 0.obs;
  late AudioPlayer player = AudioPlayer();
  Rx<PlayerState> playerState = PlayerState.paused.obs;
  Duration? duration;
  Duration? position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get isPlaying => playerState == PlayerState.playing;

  bool get isPaused => playerState == PlayerState.paused;

  String get durationText => duration?.toString().split('.').first ?? '';

  String get positionText => position?.toString().split('.').first ?? '';

  // AudioPlayer get players => widget.player;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchTimeLine(leadId.value);
    // Create the audio player.
    player = AudioPlayer();
    // Set the release mode to keep the source after playback has completed.
    player.setReleaseMode(ReleaseMode.stop);
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    player.dispose();
    super.onClose();
  }

  fetchTimeLine(int leadId) async {
    loadingState.value = true;
    activeTimeLineList.clear();
    var response = await TimeLineRepository().fetchTimeLine(leadId);
    activeTimeLineList.addAll(response);
    loadingState.value = false;
    if (activeTimeLineList.isNotEmpty) {
      firstOldStatus.value = activeTimeLineList.first.oldStatus ?? '';
      firstFollowupDate.value = activeTimeLineList.first.nextFollowUpDate ?? '';
    }
  }

  void initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      duration = duration;
      update();
    });

    _positionSubscription = player.onPositionChanged.listen(
      (p) {
        position = p;
        update();
      },
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      playerState.value = PlayerState.stopped;
      position = Duration.zero;
      update();
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      playerState.value = state;
      update();
    });
  }

  Future<void> play(String url) async {
    await player.play(UrlSource(url));
    playerState.value = PlayerState.playing;
    print(playerState.value);
    update();
  }

  Future<void> pause() async {
    await player.pause();
    playerState.value = PlayerState.paused;
    print(playerState.value);
    update();
  }

  Future<void> stop() async {
    await player.stop();
    playerState.value = PlayerState.stopped;
    position = Duration.zero;
    update();
  }
}

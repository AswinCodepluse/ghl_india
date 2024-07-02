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
  late AudioPlayer player;
  Rx<PlayerState> playerState = PlayerState.paused.obs;
  Duration? duration;
  Rx<Duration> position = Duration.zero.obs;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get isPlaying => playerState.value == PlayerState.playing;

  bool get isPaused => playerState.value == PlayerState.paused;

  String get durationText => duration?.toString().split('.').first ?? '0:00';

  String get positionText => position.value.toString().split('.').first;

  @override
  void onInit() {
    super.onInit();
    fetchTimeLine(leadId.value);
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
    initStreams();
  }

  @override
  void onClose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    player.dispose();
    super.onClose();
  }

  Future<void> onChange(double value) async {
    print('value  $value');
    await player.seek(Duration(seconds: value.toInt()));
    update();
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
    _durationSubscription = player.onDurationChanged.listen((d) {
      duration = d;
      update();
    });

    _positionSubscription = player.onPositionChanged.listen((p) {
      position.value = p;
      update();
    });

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      playerState.value = PlayerState.stopped;
      position.value = Duration.zero;
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
    print('duration ================');
    Duration? dura =await player.getDuration();
    print(dura?.inMinutes);
    print(dura?.inMilliseconds);
    print(dura?.inSeconds);
    player.onDurationChanged.listen((d) {
      print('test duration $d');
      duration = d;
      update();
    });
    update();
  }

  Future<void> pause() async {
    await player.pause();
    playerState.value = PlayerState.paused;
    update();
  }

  Future<void> stop() async {
    await player.stop();
    playerState.value = PlayerState.stopped;
    position.value = Duration.zero;
    update();
  }
}

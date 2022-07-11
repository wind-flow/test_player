import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:test_player/controller/loggerController.dart';
import 'package:test_player/controller/audioController.dart';
import 'package:test_player/model/audio.dart';

class AudioPlayerController extends GetxController {
  final AudioPlayer _advancedPlayer = AudioPlayer();

  static double playerExpandProgress = 80.toDouble();
  static double playerMaxHeight =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
  static const double miniplayerPercentageDeclaration = 0.2;

  Rx<Duration> duration = const Duration(seconds: 0).obs;
  Rx<Duration> position = const Duration(seconds: 0).obs;
  late RxString curPosition = '0'.obs;
  final RxInt currentStreamIndex = 0.obs;
  final Rx<PlayerState> playState = PlayerState.stopped.obs;
  final RxBool isPlaying = false.obs;

  RxBool isShowingPlayer = false.obs;

  final AudioController _audioController = AudioController();
  RxList<Audio> streams = <Audio>[].obs;

  final RxDouble speed = 1.0.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    final streamController = Get.put(AudioController());

    streams = await _audioController.read();

    _advancedPlayer.onDurationChanged.listen((d) {
      duration.value = d;
    });
    _advancedPlayer.onPositionChanged.listen((p) {
      position.value = p;
      curPosition.value = DurationToSecondInString(position);
      if (position.value >= duration.value) {
        next();
      }
    });

    _advancedPlayer.onPlayerStateChanged.listen((PlayerState state) async {
      (playState.value = state);
      (isPlaying.value = (state == PlayerState.playing));
    });

    _advancedPlayer.onPlayerComplete.listen((event) {
      position.value = duration.value;
      playState.value = PlayerState.completed;
    });

    await _advancedPlayer.setVolume(1.5);
    await _advancedPlayer.setPlaybackRate(speed.value);

    ever(speed, (_) async {
      await _advancedPlayer.setPlaybackRate(speed.value);
      await resume();
      await (playState.value = PlayerState.playing);
    });
  }

  //play
  Future<void> smartPlay() async {
    if (playState.value == PlayerState.playing) {
      await pause();
    } else {
      await resume();
    }
  }

  Future<void> play() async {
    await stop();
    await resume();
  }

  //play
  Future<void> resume() async {
    await _advancedPlayer.resume();
  }

  //pause
  Future<void> pause() async {
    await _advancedPlayer.pause();
  }

  //stop
  Future<void> stop() async {
    await _advancedPlayer.stop();
    position.value = Duration(seconds: 0);
  }

  Future<void> next() async {
    if (currentStreamIndex.value + 1 != streams.length) {
      currentStreamIndex.value++;
      await play();
    }
  }

  Future<void> back() async {
    if (currentStreamIndex.value - 1 != -1) {
      currentStreamIndex.value--;
      await play();
    }
  }

  Future<void> movePosition(double value, String operand) async {
    if (operand == '-') {
      if (position.value - Duration(seconds: value.toInt()) <=
          Duration(seconds: 0)) {
        position.value = Duration(seconds: 0);
        await _advancedPlayer.seek(Duration(seconds: 0));
      } else {
        await _advancedPlayer.seek(
            Duration(seconds: (position.value.inSeconds - value.toInt())));
        position.value = (position.value - Duration(seconds: value.toInt()));
      }
    } else if (operand == '+') {
      if (position.value + Duration(seconds: value.toInt()) >= duration.value) {
        position.value = duration.value;
        await _advancedPlayer.seek(duration.value);
      } else {
        await _advancedPlayer.seek(
            Duration(seconds: (position.value.inSeconds + value.toInt())));
        position.value = (position.value + Duration(seconds: value.toInt()));
      }
    }

    curPosition.value = DurationToSecondInString(position);
  }

  Future<void> setAudio(String url) async {
    await _advancedPlayer.setSourceUrl(url);
  }

  void setAudioSpeed(double speed) async {
    await _advancedPlayer.setPlaybackRate(speed);
  }

  set setPositionValue(double value) =>
      _advancedPlayer.seek(Duration(seconds: value.toInt()));

  String DurationToSecondInString(Rx<Duration> time) {
    var seconds = (time.value.inSeconds % 60).floor().toString(),
        minutes = (time.value.inSeconds / 60).floor().toString(),
        hours = (time.value.inSeconds / (24 * 60)).floor().toString();

    hours = (int.parse(hours) < 10) ? "0" + hours : hours;
    minutes = (int.parse(minutes) < 10) ? "0" + minutes : minutes;
    seconds = (int.parse(seconds) < 10) ? "0" + seconds : seconds;

    var result = (hours == '00'
        ? minutes + ":" + seconds
        : hours + ":" + minutes + ":" + seconds);

    return result.toString();
  }

  void addPlayList(Audio audio) async {
    int index = await _audioController.add(audio);
    streams.value = await _audioController.read();
  }

  void deletePlayList(int index) async {
    _audioController.delete(index);
    streams.value = await _audioController.read();
  }

  void deleteAll() async {
    _audioController.deleteAll();
  }
}

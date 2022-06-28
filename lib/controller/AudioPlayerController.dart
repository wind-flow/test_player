import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
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
    });

    _advancedPlayer.onPlayerStateChanged.listen((PlayerState state) async {
      (playState.value = state);
      (isPlaying.value = (state == PlayerState.playing));
    });

    _advancedPlayer.onPlayerComplete.listen((event) {
      position.value = duration.value;
      playState.value = PlayerState.completed;
    });

    await _advancedPlayer.setVolume(0.7);
    await _advancedPlayer.setPlaybackRate(1);

    interval(position, (time) {
      var seconds = ((time.inSeconds / 1000) % 60).floor().toString(),
          minutes = ((time.inSeconds / (1000 * 60)) % 60).floor().toString(),
          hours = ((time.inSeconds / (1000 * 60 * 60)) % 24).floor().toString();

      hours = (int.parse(hours) < 10) ? "0" + hours : hours;
      minutes = (int.parse(minutes) < 10) ? "0" + minutes : minutes;
      seconds = (int.parse(seconds) < 10) ? "0" + seconds : seconds;

      var result = hours == '00'
          ? minutes + ":" + seconds
          : hours + ":" + minutes + ":" + seconds;
      curPosition.value = result;
    }, time: Duration(seconds: 1));
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
    }
    await play();
  }

  Future<void> back() async {
    if (currentStreamIndex.value - 1 != -1) currentStreamIndex.value--;
    await play();
  }

  Future<void> movePosition(double value, String operand) async {
    if (operand == '-') {
      await _advancedPlayer
          .seek(Duration(seconds: (position.value.inSeconds - value.toInt())));
      position.value = (position.value - Duration(seconds: value.toInt()));
    } else {
      await _advancedPlayer
          .seek(Duration(seconds: (position.value.inSeconds + value.toInt())));
      position.value = (position.value + Duration(seconds: value.toInt()));
    }
  }

  Future<void> setAudio(String url) async {
    await _advancedPlayer.setSourceUrl(url);
  }

  void setAudioSpeed(double speed) async {
    await _advancedPlayer.setPlaybackRate(speed);
  }

  set setPositionValue(double value) =>
      _advancedPlayer.seek(Duration(seconds: value.toInt()));

  String DurationToSecondInString(Duration time) {
    var seconds = ((time.inSeconds / 1000) % 60).floor().toString(),
        minutes = ((time.inSeconds / (1000 * 60)) % 60).floor().toString(),
        hours = ((time.inSeconds / (1000 * 60 * 60)) % 24).floor().toString();

    hours = (int.parse(hours) < 10) ? "0" + hours : hours;
    minutes = (int.parse(minutes) < 10) ? "0" + minutes : minutes;
    seconds = (int.parse(seconds) < 10) ? "0" + seconds : seconds;

    var result = hours == '00'
        ? minutes + ":" + seconds
        : hours + ":" + minutes + ":" + seconds;

    return result;
  }

  void addPlayList(Audio audio) async {
    int result = await _audioController.add(audio);
    // .then((value) {
    //   streams.add(audio);
    // });
  }

  void deletePlayList(int index) async {
    _audioController.delete(index);
    streams = await _audioController.read();
  }
}

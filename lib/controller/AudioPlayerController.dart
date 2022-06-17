import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:test_player/controller/StreamController.dart';
import 'package:test_player/model/StreamModels.dart';

class AudioPlayerController extends GetxController {
  final AudioPlayer _advancedPlayer = AudioPlayer();

  static double playerExpandProgress = 80.toDouble();
  static double playerMaxHeight =
      (ui.window.physicalSize.height / ui.window.devicePixelRatio);
  static const double miniplayerPercentageDeclaration = 0.2;

  Rx<Duration> duration = const Duration(seconds: 0).obs;
  Rx<Duration> position = const Duration(seconds: 0).obs;
  Rx<int> currentStreamIndex = 0.obs;
  Rx<PlayerState> playState = PlayerState.stopped.obs;

  RxList<Stream> streams = <Stream>[].obs;
  RxBool isShowingPlayer = false.obs;
  
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    final streamController = Get.put(StreamController());
    streams = streamController.streams;

    _advancedPlayer.onDurationChanged.listen((d) => duration.value = d);
    _advancedPlayer.onPositionChanged.listen((p) => position.value = p);
    _advancedPlayer.onPlayerStateChanged
        .listen((PlayerState state) => playState.value = state);
    _advancedPlayer.onPlayerComplete
        .listen((event) => position.value = duration.value);
  }

  //play
  void smartPlay() async {
    if (playState.value == PlayerState.playing) {
      pause();
    } else {
      resume();
    }
  }

  void play() async {
    stop();
    resume();
  }

  //play
  void resume() async {
    await _advancedPlayer.resume();
  }

  //pause
  void pause() async {
    await _advancedPlayer.pause();
  }

  //stop
  void stop() async {
    await _advancedPlayer.stop();
    position.value = Duration(seconds: 0);
  }

  void next() {
    if (currentStreamIndex.value + 1 != streams.length) {
      currentStreamIndex.value++;
    }
    play();
  }

  void back() {
    if (currentStreamIndex.value - 1 != -1) currentStreamIndex.value--;
    play();
  }

  void movePosition(double value, String operand) {
    if (operand == '-') {
      _advancedPlayer
          .seek(Duration(seconds: (position.value.inSeconds - value.toInt())));
    } else {
      _advancedPlayer
          .seek(Duration(seconds: (position.value.inSeconds + value.toInt())));
    }
  }

  void onTab() {}

  set setPositionValue(double value) =>
      _advancedPlayer.seek(Duration(seconds: value.toInt()));
}

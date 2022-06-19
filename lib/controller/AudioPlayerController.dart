import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:test_player/controller/LoggerController.dart';
import 'package:test_player/controller/StreamController.dart';
import 'package:test_player/model/StreamModels.dart';

class AudioPlayerController extends GetxController {
  final AudioPlayer _advancedPlayer = AudioPlayer();

  static double playerExpandProgress = 80.toDouble();
  static double playerMaxHeight =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
  //     (ui.window.physicalSize.height / ui.window.devicePixelRatio);
  static const double miniplayerPercentageDeclaration = 0.2;

  Rx<Duration> duration = const Duration(seconds: 0).obs;
  Rx<Duration> position = const Duration(seconds: 0).obs;
  Rx<int> currentStreamIndex = 0.obs;
  Rx<PlayerState> playState = PlayerState.stopped.obs;
  RxBool isPlaying = false.obs;
  RxList<Stream> streams = <Stream>[].obs;
  RxBool isShowingPlayer = false.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    final streamController = Get.put(StreamController());
    streams = streamController.streams;
    final result = await FilePicker.platform.pickFiles();

    _advancedPlayer.onDurationChanged.listen((d) => duration.value = d);
    _advancedPlayer.onPositionChanged.listen((p) => position.value = p);
    _advancedPlayer.onPlayerStateChanged.listen((PlayerState state) {
      isPlaying.value = state == PlayerState.playing;
    });

    _advancedPlayer.onPlayerComplete
        .listen((event) => position.value = duration.value);

    if (result != null) {
      final file = File(result.files.single.path!);
      _advancedPlayer.setSourceDeviceFile(file.path);
    }
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
    playState.value = PlayerState.playing;
  }

  //pause
  void pause() async {
    await _advancedPlayer.pause();
    playState.value = PlayerState.paused;
  }

  //stop
  void stop() async {
    await _advancedPlayer.stop();
    position.value = Duration(seconds: 0);
    playState.value = PlayerState.stopped;
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

  void setAudio() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final file = File(result.files.single.path!);
      _advancedPlayer.setSourceDeviceFile(file.path);
    }
  }

  void onTab() {}

  set setPositionValue(double value) =>
      _advancedPlayer.seek(Duration(seconds: value.toInt()));
}

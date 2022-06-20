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
  static const double miniplayerPercentageDeclaration = 0.2;

  Rx<Duration> duration = const Duration(seconds: 0).obs;
  Rx<Duration> position = const Duration(seconds: 0).obs;
  final Rx<int> currentStreamIndex = 0.obs;
  final Rx<PlayerState> playState = PlayerState.stopped.obs;
  final RxBool isPlaying = false.obs;
  RxList<Stream> streams = <Stream>[].obs;
  RxBool isShowingPlayer = false.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    final streamController = Get.put(StreamController());
    streams = streamController.streams;

    _advancedPlayer.onDurationChanged.listen((d) => duration.value = d);
    _advancedPlayer.onPositionChanged.listen((p) => position.value = p);
    _advancedPlayer.onPlayerStateChanged.listen((PlayerState state) async {
      (playState.value = state);
      (isPlaying.value = (state == PlayerState.playing));
    });

    _advancedPlayer.onPlayerComplete
        .listen((event) => position.value = duration.value);


    await _advancedPlayer.setVolume(0.3);
    await _advancedPlayer.setPlaybackRate(1);
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
    } else {
      await _advancedPlayer
          .seek(Duration(seconds: (position.value.inSeconds + value.toInt())));
    }
  }

  Future<void> setAudio(String url) async {

    // File URL
    // final result = await FilePicker.platform.pickFiles();

    // if (result != null) {
    //   final file = File(result.files.single.path!);
    //   _advancedPlayer.setSourceDeviceFile(file.path);
    // }


    // Remote URL
    await _advancedPlayer.setSourceUrl(url);
  }

  set setPositionValue(double value) =>
      _advancedPlayer.seek(Duration(seconds: value.toInt()));
}

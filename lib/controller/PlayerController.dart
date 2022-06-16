import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

import 'package:test_player/model/models.dart';

class PlayerController extends GetxController {
    static double playerExpandProgress = 120.toDouble();
    static double playerMaxHeight = (ui.window.physicalSize.height / ui.window.devicePixelRatio);
    static const double miniplayerPercentageDeclaration = 0.2;

    Rx<Audio?> currentlyPlaying = null.obs;
    
    RxList<Audio> playAudioList = [
        const Audio('Salt & Pepper', 'Dope Lemon',
      'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.bemil.chosun.com%2Fnbrd%2Ffiles%2FBEMIL085%2Fupload%2F0568608_1.jpg&type=sc960_832'),
  const Audio('Losing It', 'FISHER',
      'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.bemil.chosun.com%2Fnbrd%2Ffiles%2FBEMIL085%2Fupload%2F0568608_1.jpg&type=sc960_832'),

    ].obs;
}
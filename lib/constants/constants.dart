import 'package:flutter/foundation.dart';

class Constants {
  static double movePostion = 5;

  static const Map<String, String> UNIT_ID = kReleaseMode
    ? {
        'ios': '[YOUR iOS AD UNIT ID]',
        'android': '[YOUR ANDROID AD UNIT ID]',
      }
    : {
        'ios_banner': 'ca-app-pub-3940256099942544/2934735716',
        'android': 'ca-app-pub-3940256099942544/6300978111',
      };
}

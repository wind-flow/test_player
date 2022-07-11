import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:test_player/controller/loggerController.dart';

import '../model/audio.dart';

const String STREAM_BOX = 'STREAM_BOX';

class AudioHiveRepository {
  static final AudioHiveRepository _singleton = AudioHiveRepository._internal();
  factory AudioHiveRepository() {
    return _singleton;
  }

  AudioHiveRepository._internal();

  Box<Audio>? audioBox;

  Future openBox() async {
    audioBox = await Hive.openBox(STREAM_BOX);
  }

  Future<int> audioCreate(Audio newAudio) async {
    return await audioBox!.add(newAudio);
  }

  Future<RxList<Audio>> audioRead() async {
    return await audioBox!.values.toList().obs;
  }

  Future audioUpdate(int index, Audio updatedAudio) async {
    return await audioBox!.putAt(index, updatedAudio);
  }

  Future audioDelete(int index) async {
    return audioBox!.deleteAt(index);
  }

  Future audioDeleteAll() async {
    return audioBox!.deleteFromDisk();
  }
}

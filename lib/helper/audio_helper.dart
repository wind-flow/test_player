import 'package:hive/hive.dart';

import '../model/audio.dart';

const String STREAM_BOX = 'STREAM_BOX';

class AudioHiveHelper {
  static final AudioHiveHelper _singleton = AudioHiveHelper._internal();
  factory AudioHiveHelper() {
    return _singleton;
  }

  AudioHiveHelper._internal();

  Box<Audio>? audioBox;

  Future openBox() async {
    audioBox = await Hive.openBox(STREAM_BOX);
  }

  Future audioCreate(Audio newAudio) async {
    return await audioBox!.add(newAudio);
  }

  Future<List<Audio>> audioRead() async {
    return await audioBox!.values.toList();
  }

  Future audioUpdate(int index, Audio updatedAudio) async {
    return await audioBox!.putAt(index, updatedAudio);
  }

  Future audioDelete(int index) async {
    return audioBox!.delete(index);
  }

}

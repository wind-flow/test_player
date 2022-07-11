import 'package:get/get.dart';
import 'package:test_player/controller/loggerController.dart';
import 'package:test_player/repository/audio_hive_repository.dart';
import '../model/audio.dart';

class AudioController extends GetxController {
  AudioHiveRepository audioRepository = AudioHiveRepository();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<int> add(Audio audio) async {
    return await audioRepository.audioCreate(audio);
  }

  Future<RxList<Audio>> read() async {
    var result = await audioRepository.audioRead();
    return result;
  }

  void delete(int index) async {
    await audioRepository.audioDelete(index);
  }

  void deleteAll() async {
    await audioRepository.audioDeleteAll();
  }
}

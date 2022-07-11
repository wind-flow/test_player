import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sizer/sizer.dart';
import 'package:test_player/controller/LoggerController.dart';
import 'package:test_player/controller/audioPlayerController.dart';
import 'package:test_player/repository/audio_hive_repository.dart';
import 'package:test_player/model/audio.dart';
import 'screens/audio_ui.dart';
import 'widgets/player.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';
import 'constants/utils.dart';
import 'package:flutter/services.Dart' show rootBundle;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AudioAdapter());
  await AudioHiveRepository().openBox();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

// void main() => runApp(
//       const MyApp(),
//     );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: 'DD Player',
        theme: ThemeData(
          brightness: Brightness.dark,
          // sliderTheme: SliderThemeData(
          //     rangeThumbShape: RoundRangeSliderThumbShape(
          //         enabledThumbRadius: 20, elevation: 20)),
        ),
        darkTheme: ThemeData.dark(),
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        useInheritedMediaQuery: true,
        home: MyHomePage(),
      );
    });
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayerController = Get.put(AudioPlayerController());

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(
                title: Text('DD Player'),
                actions: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.audio_file),
                    tooltip: 'select audio',
                    iconSize: 40,
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(allowMultiple: true);

                      if (result != null) {
                        List<File> _files =
                            result.paths.map((path) => File(path!)).toList();

                        _files.forEach((f) async {
                          final file = File(f.path);
                          final _metadata =
                              await MetadataRetriever.fromFile(File(file.path));

                          // print(_metadata.albumArt);

                          // Uint8List stuff = Image(image: "defaultimage.jpg").toByteData().buffer.asUInt8List();

                          Uint8List bytes = await rootBundle
                                  .load('assets/images/defaultAudioImage.png')
                              as Uint8List;

                          print('${_metadata.albumArt}');
                          print('${_metadata.albumArtistName}');
                          print('${_metadata.trackName}');

                          String _unknown = 'unKnown';

                          audioPlayerController.deleteAll();
                          // Audio audio = Audio(
                          //     id: audioPlayerController.streams.length,
                          //     music: file.path,
                          //     picture: _metadata.albumArt ?? bytes,
                          //     composer: _metadata.albumArtistName ?? _unknown,
                          //     title: _metadata.trackName ?? _unknown,
                          //     long: DurationToSecondInString(
                          //         Duration(seconds: _metadata.trackDuration!)));
                          // audioPlayerController.addPlayList(audio);
                        });

                        // final _result = await FilePicker.platform.pickFiles();

                        // if (result != null) {
                        //   final _file = File(result.files.single.path!);
                        //   final _metadata = await MetadataRetriever.fromFile(File(_file.path));

                        // final _metadata =
                        //     await MetadataRetriever.fromFile(File(_file.path));

                        // Audio audio = Audio(
                        //     id: audioPlayerController.streams.length,
                        //     music: _file.path,
                        //     picture: _metadata.albumArt,
                        //     composer: _metadata.albumArtistName,
                        //     title: _metadata.trackName,
                        //     long: DurationToSecondInString(
                        //         Duration(seconds: _metadata.trackDuration!)));
                        // audioPlayerController.addPlayList(audio);
                        // } else {
                        //   // User canceled the picker
                        // }
                      }
                    },
                  )
                ],
              ),
              Expanded(
                child: AudioUi(),
              ),
            ],
          ),
          Obx(() {
            if (audioPlayerController.isShowingPlayer.value)
              return LimitedBox(
                  maxHeight: AudioPlayerController.playerMaxHeight,
                  maxWidth: MediaQuery.of(context).size.width,
                  child: DetailedPlayer(
                      audio: audioPlayerController.streams[
                          audioPlayerController.currentStreamIndex.value]));
            else
              return Container();
          })
          // Obx(() {
          //   print(audioPlayerController.isShowingPlayer.value);
          //   return Offstage(
          //     offstage: !audioPlayerController.isShowingPlayer.value,
          //     child: DetailedPlayer(audio: audioPlayerController.streams[0]),
          //   );
          // })
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   selectedItemColor: Colors.blue,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(icon: Icon(Icons.audiotrack), label: 'Audio'),
      //     BottomNavigationBarItem(icon: Icon(Icons.videocam), label: 'Video'),
      //   ],
      // ),
      // bottomNavigationBar: ValueListenableBuilder(
      //   valueListenable: playerExpandProgress,
      //   builder: (BuildContext context, double height, Widget? child) {
      //     final value = percentageFromValueInRange(
      //         min: playerMinHeight, max: playerMaxHeight, value: height);

      //     var opacity = 1 - value;
      //     if (opacity < 0) opacity = 0;
      //     if (opacity > 1) opacity = 1;

      //     return SizedBox(
      //       height:
      //           kBottomNavigationBarHeight - kBottomNavigationBarHeight * value,
      //       child: Transform.translate(
      //         offset: Offset(0.0, kBottomNavigationBarHeight * value * 0.5),
      //         child: Offstage(
      //           // opacity: opacity,
      //           offstage: false,
      //           child: OverflowBox(
      //             maxHeight: kBottomNavigationBarHeight,
      //             child: child,
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      //   child: BottomNavigationBar(
      //     currentIndex: 0,
      //     selectedItemColor: Colors.blue,
      //     items: <BottomNavigationBarItem>[
      //       BottomNavigationBarItem(icon: Icon(Icons.audiotrack), label: 'Audio'),
      //       BottomNavigationBarItem(
      //           icon: Icon(Icons.videocam), label: 'Video'),
      //     ],
      //   ),
      // ),
    );
  }
}

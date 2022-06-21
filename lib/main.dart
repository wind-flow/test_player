import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:sizer/sizer.dart';
import 'package:test_player/controller/AudioPlayerController.dart';
import 'package:test_player/controller/LoggerController.dart';
import 'package:test_player/model/StreamModels.dart';
import 'screens/audio_screen.dart';
import 'widgets/player.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';

void main() => runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MyApp(), // Wrap your app
      ),
    );

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
        theme: ThemeData.dark(),
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
                    tooltip: 'Wow',
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles();

                      if (result != null) {
                        final _file = File(result.files.single.path!);
                        final _metadata =
                            await MetadataRetriever.fromFile(File(_file.path));

                        // LoggerController.logger.d(_metadata.albumArtistName);
                        // LoggerController.logger.d(_metadata.trackArtistNames);
                        // LoggerController.logger.d(_metadata.trackName);
                        // LoggerController.logger.d(_metadata.authorName);
                        Stream audio = Stream(
                          id: audioPlayerController.streams.length,
                          music: _file.path,
                          picture: _metadata.albumArt,
                          composer: _metadata.albumArtistName,
                          title: _metadata.trackName,
                          long: _metadata.trackDuration.toString(),
                        );

                        audioPlayerController.streams.add(audio);
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.audiotrack), label: 'Audio'),
          BottomNavigationBarItem(icon: Icon(Icons.videocam), label: 'Video'),
        ],
      ),
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

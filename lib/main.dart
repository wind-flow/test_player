import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sizer/sizer.dart';
import 'package:test_player/controller/AudioPlayerController.dart';
import 'model/StreamModels.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: 'Miniplayer Demo',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        useInheritedMediaQuery: true,
        home: MyHomePage(),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final audioPlayerController = Get.put(AudioPlayerController());

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(title: Text('Miniplayer Demo')),
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
                  child:
                      DetailedPlayer(audio: audioPlayerController.streams[0]));
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

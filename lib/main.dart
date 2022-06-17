import 'package:flutter/material.dart';
import 'package:test_player/controller/PlayerController.dart';
import 'model/models.dart';
import 'screens/audio_screen.dart';
import 'widgets/player.dart';
import 'utils.dart';
import 'package:get/get.dart';

ValueNotifier<Audio?> currentlyPlaying = ValueNotifier(null);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Miniplayer Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: MyHomePage(),
    );
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
    final playerController = Get.put(PlayerController());

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(title: Text('Miniplayer Demo')),
              Expanded(
                child: AudioUi(
                  onTap: (audio) => currentlyPlaying.value = audio,
                ),
              ),
            ],
          ),
          // DetailedPlayer(audio: playerController.currentlyPlaying.value!),
          // DetailedPlayer(audio: playerController.currentlyPlaying.value!)
          ValueListenableBuilder(
            valueListenable: currentlyPlaying,
            builder: (BuildContext context, Audio? audio, Widget? child) =>
                audio != null ? DetailedPlayer(audio: audio) : Container(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          selectedItemColor: Colors.blue,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.audiotrack), label: 'Audio'),
            BottomNavigationBarItem(
                icon: Icon(Icons.videocam), label: 'Video'),
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

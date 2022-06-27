import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:test_player/controller/audioPlayerController.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:test_player/controller/loggerController.dart';
import 'package:test_player/helper/audio_helper.dart';
import 'package:test_player/model/audio.dart';

class AudioUi extends StatelessWidget {
  const AudioUi({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayerController = Get.put(AudioPlayerController());
    return Obx(
      () => FutureBuilder(
        future: AudioHiveHelper().audioRead(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 15),
                ),
              );
          } else {
            return ListView.builder(
              itemCount: audioPlayerController.streams.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: ((context, index) {
                return Obx(() => (Dismissible(
                  key: Key(
                      audioPlayerController.streams[index].id.toString()),
                  onDismissed: (direction) {
                    audioPlayerController.removePlayList(index);
                  },
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.sp),
                    ),
                    onTap: () async {
                      if (audioPlayerController.currentStreamIndex.value !=
                              index ||
                          audioPlayerController.isPlaying == false) {
                        audioPlayerController.currentStreamIndex.value =
                            index;
                        await audioPlayerController.setAudio(
                            audioPlayerController.streams[index].music!);
                        audioPlayerController.play();
                      } else {
                        audioPlayerController.smartPlay();
                      }
                      audioPlayerController.isShowingPlayer.value = true;
                    },
                    child: Container(
                      height: 52.sp,
                      decoration: BoxDecoration(
                        color: (audioPlayerController
                                    .currentStreamIndex.value ==
                                index)
                            ? Color(0xFF2A2A2A)
                            : Colors.transparent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.sp),
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 13.sp),
                            child: Container(
                              height: 35.sp,
                              width: 35.sp,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(15.sp)),
                                child: Image.memory(
                                  audioPlayerController
                                      .streams[index].picture!,
                                  frameBuilder: (BuildContext context,
                                      Widget child,
                                      int? frame,
                                      bool wasSynchronouslyLoaded) {
                                    return (frame != null)
                                        ? child
                                        : Padding(
                                            padding: EdgeInsets.all(8.sp),
                                            child:
                                                CircularProgressIndicator(
                                              strokeWidth: 5.sp,
                                              color: Color(0xFF71B77A),
                                            ),
                                          );
                                  },
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      color: Color(0xFF71B77A),
                                      child: Center(
                                        child: Text("404"),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      audioPlayerController
                                          .streams[index].composer!,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Color(0xFFACACAC),
                                        fontWeight: FontWeight.w300,
                                        fontFamily: "Segoe UI",
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: 15.sp),
                                      child: Text(
                                        audioPlayerController
                                            .streams[index].long!,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Color(0xFFACACAC),
                                          fontWeight: FontWeight.w300,
                                          fontFamily: "Segoe UI",
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  audioPlayerController
                                      .streams[index].title!,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )));
              }),
            );
          }
        },
      ),
    );
  }
}

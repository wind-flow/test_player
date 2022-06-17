import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:test_player/controller/LoggerController.dart';
import 'package:test_player/controller/AudioPlayerController.dart';
import 'package:test_player/widgets/player.dart';
import '../model/StreamModels.dart';
import '../widgets/audio_list_tile.dart';
import 'package:get/get.dart';
import '../utils.dart';
import 'package:sizer/sizer.dart';
// typedef OnTap(final Audio audio);

class AudioUi extends StatelessWidget {
  const AudioUi({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayerController = Get.put(AudioPlayerController());
    return Obx(
      () => ListView.builder(
        itemCount: audioPlayerController.streams.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: ((context, index) {
          return InkWell(
            borderRadius: BorderRadius.all(
              Radius.circular(10.sp),
            ),
            onTap: () {
              audioPlayerController.currentStreamIndex.value = index;
              audioPlayerController.play();
              audioPlayerController.isShowingPlayer(true);
              LoggerController.logger.d(audioPlayerController.isShowingPlayer);
              // return AudioListTile(
              //   audio: playController.playAudioList[index],
              // );
              // onTap: onTap(playController.playAudioList[index]));
              audioPlayerController.playState.value = PlayerState.playing;
            },
            child: Obx(
              () => Container(
                height: 52.sp,
                decoration: BoxDecoration(
                  color: (audioPlayerController.currentStreamIndex.value == index)
                      ? Color(0xFF2A2A2A)
                      : Colors.transparent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.sp),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13.sp),
                      child: Container(
                        height: 35.sp,
                        width: 35.sp,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.sp)),
                          child: Image.network(
                            audioPlayerController.streams[index].picture!,
                            frameBuilder: (BuildContext context, Widget child,
                                int? frame, bool wasSynchronouslyLoaded) {
                              return (frame != null)
                                  ? child
                                  : Padding(
                                      padding: EdgeInsets.all(8.sp),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 5.sp,
                                        color: Color(0xFF71B77A),
                                      ),
                                    );
                            },
                            errorBuilder: (context, error, stackTrace) {
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                audioPlayerController.streams[index].composer!,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Color(0xFFACACAC),
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Segoe UI",
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 15.sp),
                                child: Text(
                                  audioPlayerController.streams[index].long!,
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
                            audioPlayerController.streams[index].title!,
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
          );
        }),
      ),
    );
    // return ListView(
    //   padding: const EdgeInsets.all(0),
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.only(left: 10, bottom: 6, top: 15),
    //       child: Text('Your Library:'),
    //     ),
    //     for (Audio a in audioExamples)
    //       AudioListTile(audio: a, onTap: () => onTap(a))
    //   ],
    // );
  }
}

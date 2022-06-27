import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:test_player/controller/audioPlayerController.dart';

class PlayListCell extends StatelessWidget {
  PlayListCell(var audioPlayerController, int index, {Key? key}) : super(key: key);

  late var playerController;
  late int index;

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return InkWell(
            borderRadius: BorderRadius.all(
              Radius.circular(10.sp),
            ),
            onTap: () async {
              if (playerController.currentStreamIndex.value != index ||
                  playerController.isPlaying == false) {
                playerController.currentStreamIndex.value = index;
                await playerController
                    .setAudio(playerController.streams[index].music!);
                playerController.play();
              } else {
                playerController.smartPlay();
              }
              playerController.isShowingPlayer.value = true;
            },
            child: Container(
              height: 52.sp,
              decoration: BoxDecoration(
                color: (playerController.currentStreamIndex.value == index)
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
                        borderRadius: BorderRadius.all(Radius.circular(15.sp)),
                        child: Image.memory(
                          playerController.streams[index].picture!,
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
                              playerController.streams[index].composer!,
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
                                playerController.streams[index].long!,
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
                          playerController.streams[index].title!,
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
            )
          );
      },
    );
  }
}

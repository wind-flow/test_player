import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:test_player/constants/constants.dart';
import 'package:test_player/controller/audioPlayerController.dart';
import 'package:test_player/controller/loggerController.dart';
import '../constants/utils.dart';
import 'package:get/get.dart';
import '../model/audio.dart';

class DetailedPlayer extends StatelessWidget {
  final Audio audio;

  DetailedPlayer({
    Key? key,
    required this.audio,
  }) : super(key: key);

  final audioPlayerController = Get.put(AudioPlayerController());
  final MiniplayerController controller = MiniplayerController();

  @override
  Widget build(BuildContext context) {
    double playerMinHeight = MediaQuery.of(context).size.height * 0.1;
    double playerMaxHeight = AudioPlayerController.playerMaxHeight;
    const miniplayerPercentageDeclaration = 0.1;

    final ValueNotifier<double> playerExpandProgress =
        ValueNotifier(playerMinHeight);

    RxBool isRepeated = false.obs;
    RxBool isShowSpeedSetting = true.obs;

    Rx<RangeValues> rangeValues = RangeValues(0.0,
            audioPlayerController.duration.value.inSeconds.toDouble() + 1.0)
        .obs;

    return Miniplayer(
      valueNotifier: playerExpandProgress,
      minHeight: playerMinHeight,
      maxHeight: playerMaxHeight,
      controller: controller,
      elevation: 3,
      onDismissed: () {
        audioPlayerController.stop();
        audioPlayerController.isShowingPlayer(false);
      },
      curve: Curves.easeOut,
      builder: (height, percentage) {
        final bool miniplayer = percentage < miniplayerPercentageDeclaration;
        final double width = MediaQuery.of(context).size.width;
        final maxImgSize = width;

        final albumImg = Image.memory(
          audio.picture!,
          fit: BoxFit.contain,
        );

        //Declare additional widgets (eg. SkipButton) and variables
        if (!miniplayer) {
          var percentageExpandedPlayer = percentageFromValueInRange(
              min: playerMaxHeight * miniplayerPercentageDeclaration +
                  playerMinHeight,
              max: playerMaxHeight,
              value: height);
          if (percentageExpandedPlayer < 0) percentageExpandedPlayer = 0;
          final paddingVertical = valueFromPercentageInRange(
              min: 0, max: 10, percentage: percentageExpandedPlayer);
          final double heightWithoutPadding = height - paddingVertical * 2;
          final double imageSize = heightWithoutPadding > maxImgSize
              ? maxImgSize
              : heightWithoutPadding;
          final paddingLeft = valueFromPercentageInRange(
                min: 0,
                max: width - imageSize,
                percentage: percentageExpandedPlayer,
              ) /
              2;

          return Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: paddingLeft,
                      top: paddingVertical,
                      bottom: paddingVertical),
                  child: SizedBox(
                    height: imageSize,
                    child: albumImg,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33),
                  child: Opacity(
                    opacity: percentageExpandedPlayer,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: MarqueeText(
                            text: TextSpan(
                              text: audio.title!,
                            ),
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                            speed: 25,
                          ),
                        ),
                        Flexible(
                          child: Text(audio.composer!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .color!
                                        .withOpacity(0.55),
                                  ),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.swipe),
                                iconSize: 35,
                                onPressed: () {
                                  isRepeated.value = !isRepeated.value;
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.replay_5),
                                iconSize: 35,
                                onPressed: () =>
                                    audioPlayerController.movePosition(
                                        Constants.movePostion.toDouble(), '-'),
                              ),
                              Obx(
                                () => IconButton(
                                  icon: Icon(
                                      audioPlayerController.isPlaying.value &&
                                              audioPlayerController.playState !=
                                                  PlayerState.completed
                                          ? Icons.pause_circle_filled
                                          : Icons.play_circle_filled),
                                  iconSize: 50,
                                  onPressed: () =>
                                      audioPlayerController.smartPlay(),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.forward_5),
                                iconSize: 35,
                                onPressed: () =>
                                    audioPlayerController.movePosition(
                                        Constants.movePostion.toDouble(), '+'),
                              ),
                              IconButton(
                                  icon: Icon(Icons.fast_forward),
                                  iconSize: 35,
                                  onPressed: () {
                                    isShowSpeedSetting.value =
                                        !isShowSpeedSetting.value;
                                  }),
                            ],
                          ),
                        ),
                        Obx(
                          () => Flexible(
                            child: Offstage(
                              offstage: isShowSpeedSetting.value,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.arrow_back_ios),
                                      iconSize: 35,
                                      onPressed: () {
                                        audioPlayerController.speed.value -=
                                            0.05;
                                      }),
                                  Text(
                                    '${audioPlayerController.speed.value.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.arrow_forward_ios),
                                      iconSize: 35,
                                      onPressed: () {
                                        audioPlayerController.speed.value +=
                                            0.05;
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() {
                                  return Flexible(
                                    child: Text(
                                      '${audioPlayerController.curPosition.value}',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  );
                                }),
                                Obx(
                                  () => isRepeated.value
                                      ? Flexible(
                                          child: RangeSlider(
                                              activeColor: Color(0xFF71B77A),
                                              inactiveColor: Color(0xFFEFEFEF),
                                              min: 0.0,
                                              max: audioPlayerController
                                                      .duration.value.inSeconds
                                                      .toDouble() +
                                                  1.0,
                                              onChanged: (RangeValues value) {
                                                rangeValues.value = value;
                                              },
                                              labels: RangeLabels(
                                                rangeValues.value.start
                                                    .round()
                                                    .toString(),
                                                rangeValues.value.end
                                                    .round()
                                                    .toString(),
                                              ),
                                              values: rangeValues.value),
                                        )
                                      : Slider(
                                          activeColor: Color(0xFF71B77A),
                                          inactiveColor: Color(0xFFEFEFEF),
                                          value: audioPlayerController
                                              .position.value.inSeconds
                                              .toDouble(),
                                          min: 0.0,
                                          max: audioPlayerController
                                                  .duration.value.inSeconds
                                                  .toDouble() +
                                              1.0,
                                          label: audioPlayerController
                                              .position.value.inSeconds
                                              .toString(),
                                          onChanged: (double value) {
                                            audioPlayerController
                                                .setPositionValue = value;
                                          },
                                          onChangeEnd: (double value) async {
                                            audioPlayerController
                                                .setPositionValue = value;
                                            await audioPlayerController
                                                .resume();
                                          },
                                        ),
                                ),
                                Text(
                                  audioPlayerController
                                      .streams[audioPlayerController
                                          .currentStreamIndex
                                          .toInt()]
                                      .long!,
                                  style: TextStyle(fontSize: 25),
                                ),
                              ]),
                        ),
                        Container(),
                        Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        //Miniplayer
        final percentageMiniplayer = percentageFromValueInRange(
            min: playerMinHeight,
            max: playerMaxHeight * miniplayerPercentageDeclaration +
                playerMinHeight,
            value: height);

        late final elementOpacity;

        if ((1 - 1 * percentageMiniplayer) > 1) {
          elementOpacity = 1;
        } else if ((1 - 1 * percentageMiniplayer) < 0) {
          elementOpacity = 0;
        } else {
          elementOpacity = (1 - 1 * percentageMiniplayer);
        }

        final progressIndicatorHeight = 4 - 4 * percentageMiniplayer;

        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxImgSize),
                    child: albumImg,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Opacity(
                        opacity: elementOpacity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MarqueeText(
                              text: TextSpan(
                                text: audio.title!,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              speed: 15,
                            ),
                            Text(audio.composer!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .color!
                                          .withOpacity(0.55),
                                    ),
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.replay_5),
                    onPressed: () => audioPlayerController.movePosition(
                        Constants.movePostion, '-'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Opacity(
                      opacity: elementOpacity,
                      child: Obx(
                        () => IconButton(
                            icon: Icon(
                              audioPlayerController.isPlaying.value &&
                                      audioPlayerController.playState !=
                                          PlayerState.completed
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            onPressed: () async {
                              audioPlayerController.smartPlay();
                            }),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.forward_5),
                    onPressed: () => audioPlayerController.movePosition(
                        Constants.movePostion, '+'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: progressIndicatorHeight,
              child: Opacity(
                opacity: elementOpacity,
                child: Obx(() {
                  return LinearProgressIndicator(
                      value: (audioPlayerController.position.value.inSeconds
                                  .toDouble() +
                              1) /
                          (audioPlayerController.duration.value.inSeconds
                                  .toDouble() +
                              1));
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

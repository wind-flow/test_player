// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:test_player/controller/AudioPlayerController.dart';
import 'package:test_player/controller/LoggerController.dart';
// import 'package:example/main.dart';
import '../main.dart';
import '../model/StreamModels.dart';
import '../utils.dart';
import 'package:get/get.dart';



class DetailedPlayer extends StatelessWidget {
  final Stream audio;

  DetailedPlayer({
    Key? key,
    required this.audio,
  }) : super(key: key);

  var audioPlayerController = Get.put(AudioPlayerController());
  final MiniplayerController controller = MiniplayerController();
  
  @override
  Widget build(BuildContext context) {
    double playerMinHeight = AudioPlayerController.playerExpandProgress;
    double playerMaxHeight = AudioPlayerController
        .playerMaxHeight; //MediaQuery.of(context).size.height;
    const miniplayerPercentageDeclaration = 0.2;

    final ValueNotifier<double> playerExpandProgress =
        ValueNotifier(playerMinHeight);

    return Miniplayer(
      valueNotifier: playerExpandProgress,
      minHeight: playerMinHeight,
      maxHeight: playerMaxHeight,
      controller: controller,
      elevation: 4,
      onDismissed: () {
        currentlyPlaying.value = null;
        audioPlayerController.isShowingPlayer(false);
        LoggerController.logger.d(audioPlayerController.isShowingPlayer);
      },
      curve: Curves.easeOut,
      builder: (height, percentage) {
        final bool miniplayer = percentage < miniplayerPercentageDeclaration;
        final double width = MediaQuery.of(context).size.width;
        final maxImgSize = width;

        final img = Image.network(
          audio.picture!,
          fit: BoxFit.contain,
        );
        final text = Text(audio.title!);
        const buttonPlay = IconButton(
          icon: Icon(Icons.pause),
          onPressed: onTap,
        );
        const progressIndicator = LinearProgressIndicator(value: 0.3);

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

          const buttonSkipForward = IconButton(
            icon: Icon(Icons.forward_10),
            iconSize: 35,
            onPressed: onTap, //audioPlayerController.movePosition(10, '+'),
          );
          const buttonSkipBackwards = IconButton(
            icon: Icon(Icons.replay_10),
            iconSize: 35,
            onPressed: onTap, //audioPlayerController.movePosition(10, '-'),
          );
          const buttonPlayExpanded = IconButton(
            icon: Icon(Icons.pause_circle_filled),
            iconSize: 50,
            onPressed: onTap,
          );

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
                    child: img,
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
                        Flexible(child: text),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buttonSkipBackwards,
                              buttonPlayExpanded,
                              buttonSkipForward
                            ],
                          ),
                        ),
                        Flexible(child: progressIndicator),
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

        final elementOpacity = 1 - 1 * percentageMiniplayer;
        final progressIndicatorHeight = 4 - 4 * percentageMiniplayer;

        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxImgSize),
                    child: img,
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
                            Text(audio.title!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(fontSize: 16)),
                            Text(
                              audio.composer!,
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.fullscreen),
                      onPressed: () {
                        controller.animateToHeight(state: PanelState.MAX);
                      }),
                  Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Opacity(
                      opacity: elementOpacity,
                      child: buttonPlay,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: progressIndicatorHeight,
              child: Opacity(
                opacity: elementOpacity,
                child: progressIndicator,
              ),
            ),
          ],
        );
      },
    );
  }
}

void onTap() {}

import 'package:flutter/material.dart';
import 'package:test_player/controller/PlayerController.dart';
import '../model/models.dart';
import '../widgets/audio_list_tile.dart';
import 'package:get/get.dart';
import '../utils.dart';

typedef OnTap(final Audio audio);

const Set<Audio> audioExamples = {
  Audio('Salt & Pepper', 'Dope Lemon',
      'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.bemil.chosun.com%2Fnbrd%2Ffiles%2FBEMIL085%2Fupload%2F0568608_1.jpg&type=sc960_832'),
  Audio('Losing It', 'FISHER',
      'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.bemil.chosun.com%2Fnbrd%2Ffiles%2FBEMIL085%2Fupload%2F0568608_1.jpg&type=sc960_832'),
  Audio('American Kids', 'Kenny Chesney',
      'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.bemil.chosun.com%2Fnbrd%2Ffiles%2FBEMIL085%2Fupload%2F0568608_1.jpg&type=sc960_832'),
  Audio('Wake Me Up', 'Avicii',
      'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.bemil.chosun.com%2Fnbrd%2Ffiles%2FBEMIL085%2Fupload%2F0568608_1.jpg&type=sc960_832'),
  Audio('Missing You', 'Mesto',
      'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.bemil.chosun.com%2Fnbrd%2Ffiles%2FBEMIL085%2Fupload%2F0568608_1.jpg&type=sc960_832'),
  Audio('Drop it dirty', 'Tavengo',
      'https://search.pstatic.net/sunny/?src=https%3A%2F%2Fassets.community.lomography.com%2Fb5%2Fceff057263977a2b613cce71bb2210d91f2c00%2F1200x796x1.jpg%3Fauth%3Da23619696280d4d52facbb414d389dfaca98b785&type=sc960_832'),
  Audio('Cigarettes', 'Tash Sultana',
      'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2F20130329_165%2Fyanagi0221_1364530314015TmE8a_JPEG%2Fjmsdf_dd158_001.jpg&type=sc960_832'),
  Audio('Ego Death', 'Ty Dolla \$ign, Kanye West, FKA Twigs, Skrillex',
      'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2F20130329_165%2Fyanagi0221_1364530314015TmE8a_JPEG%2Fjmsdf_dd158_001.jpg&type=sc960_832'),
};

class AudioUi extends StatelessWidget {
  final OnTap onTap;

  const AudioUi({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playController = Get.put(PlayerController());
    // return ListView.builder(
    //     itemCount: playController.playAudioList.length,
    //     itemBuilder: ((context, index) {
    //       return AudioListTile(
    //           audio: playController.playAudioList[index],
    //           onTap: onTap(playController.playAudioList[index]));
    //     }));
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 6, top: 15),
          child: Text('Your Library:'),
        ),
        for (Audio a in audioExamples)
          AudioListTile(audio: a, onTap: () => onTap(a))
      ],
    );
  }
}

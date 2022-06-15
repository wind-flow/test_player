import 'package:flutter/material.dart';
import '../widgets/audio_list_tile.dart';

import '../utils.dart';

typedef OnTap(final AudioObject audioObject);

const Set<AudioObject> audioExamples = {
  AudioObject('Salt & Pepper', 'Dope Lemon',
      'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.bemil.chosun.com%2Fnbrd%2Ffiles%2FBEMIL085%2Fupload%2F0568608_1.jpg&type=sc960_832'),
  AudioObject('Losing It', 'FISHER',
      'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.bemil.chosun.com%2Fnbrd%2Ffiles%2FBEMIL085%2Fupload%2F0568608_1.jpg&type=sc960_832'),
  AudioObject('American Kids', 'Kenny Chesney',
      'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.bemil.chosun.com%2Fnbrd%2Ffiles%2FBEMIL085%2Fupload%2F0568608_1.jpg&type=sc960_832'),
  AudioObject('Wake Me Up', 'Avicii',
      'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.bemil.chosun.com%2Fnbrd%2Ffiles%2FBEMIL085%2Fupload%2F0568608_1.jpg&type=sc960_832'),
  AudioObject('Missing You', 'Mesto',
      'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.bemil.chosun.com%2Fnbrd%2Ffiles%2FBEMIL085%2Fupload%2F0568608_1.jpg&type=sc960_832'),
  AudioObject('Drop it dirty', 'Tavengo',
      'https://search.pstatic.net/sunny/?src=https%3A%2F%2Fassets.community.lomography.com%2Fb5%2Fceff057263977a2b613cce71bb2210d91f2c00%2F1200x796x1.jpg%3Fauth%3Da23619696280d4d52facbb414d389dfaca98b785&type=sc960_832'),
  AudioObject('Cigarettes', 'Tash Sultana',
      'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2F20130329_165%2Fyanagi0221_1364530314015TmE8a_JPEG%2Fjmsdf_dd158_001.jpg&type=sc960_832'),
  AudioObject('Ego Death', 'Ty Dolla \$ign, Kanye West, FKA Twigs, Skrillex',
      'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2F20130329_165%2Fyanagi0221_1364530314015TmE8a_JPEG%2Fjmsdf_dd158_001.jpg&type=sc960_832'),
};

class AudioUi extends StatelessWidget {
  final OnTap onTap;

  const AudioUi({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 6, top: 15),
          child: Text('Your Library:'),
        ),
        for (AudioObject a in audioExamples)
          AudioListTile(audioObject: a, onTap: () => onTap(a))
      ],
    );
  }
}
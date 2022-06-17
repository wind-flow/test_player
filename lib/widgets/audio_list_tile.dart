// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../model/StreamModels.dart';
import '../utils.dart';

// typedef OnTap(Audio audioObject);

class AudioListTile extends StatelessWidget {
  final Stream audio;
  const AudioListTile({
    Key? key,
    required this.audio,
  }) : super(key: key);
  // final Function onTap;

  // const AudioListTile(
  //     {Key? key, required this.audio, required this.onTap})
  //     : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // onTap: () => {print('ticccc')},
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          audio.picture!,
          width: 52,
          height: 52,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(audio.title!),
      subtitle: Text(
        audio.composer!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      // trailing: IconButton(
      //   icon: Icon(Icons.play_arrow_outlined),
      //   onPressed: () => onTap(),
      // ),
    );
  }
}

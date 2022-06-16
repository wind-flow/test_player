import 'package:flutter/material.dart';

import '../model/models.dart';
import '../utils.dart';

typedef OnTap(Audio audioObject);

class AudioListTile extends StatelessWidget {
  final Audio audio;
  final Function onTap;

  const AudioListTile(
      {Key? key, required this.audio, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => {print('ticccc')},
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          audio.img,
          width: 52,
          height: 52,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(audio.title),
      subtitle: Text(
        audio.subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: Icon(Icons.play_arrow_outlined),
        onPressed: () => onTap(),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'audio.g.dart';

@HiveType(typeId: 0)
class Audio extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? music;

  @HiveField(2)
  final Uint8List? picture;

  @HiveField(3)
  final String? composer;

  @HiveField(4)
  final String? title;

  @HiveField(5)
  final String? long;

  Audio({
    this.id,
    this.music,
    this.picture,
    this.composer,
    this.title,
    this.long,
  });

  get audios => null;
}

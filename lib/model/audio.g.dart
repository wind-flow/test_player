// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioAdapter extends TypeAdapter<Audio> {
  @override
  final int typeId = 0;

  @override
  Audio read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Audio(
      id: fields[0] as int?,
      music: fields[1] as String?,
      picture: fields[2] as Uint8List?,
      composer: fields[3] as String?,
      title: fields[4] as String?,
      long: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Audio obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.music)
      ..writeByte(2)
      ..write(obj.picture)
      ..writeByte(3)
      ..write(obj.composer)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.long);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

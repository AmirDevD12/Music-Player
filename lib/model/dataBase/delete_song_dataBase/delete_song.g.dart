// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_song.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeleteSongAdapter extends TypeAdapter<DeleteSong> {
  @override
  final int typeId = 2;

  @override
  DeleteSong read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeleteSong(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DeleteSong obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.pathSong);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeleteSongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_recent_play.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentPlayAdapter extends TypeAdapter<RecentPlay> {
  @override
  final int typeId = 4;

  @override
  RecentPlay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentPlay(
      fields[0] as String?,
      fields[1] as String?,
      fields[3] as int?,
      fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RecentPlay obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentPlayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

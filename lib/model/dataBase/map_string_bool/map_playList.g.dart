// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_playList.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MapPlayListAdapter extends TypeAdapter<MapPlayList> {
  @override
  final int typeId = 6;

  @override
  MapPlayList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MapPlayList(
      fields[0] as String,
      fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MapPlayList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.check);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapPlayListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_play_list_recent_add.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddTOPlayListRecentAdapter extends TypeAdapter<AddTOPlayListRecent> {
  @override
  final int typeId = 3;

  @override
  AddTOPlayListRecent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddTOPlayListRecent(
      fields[0] as String?,
      fields[1] as String?,
      fields[3] as int?,
      fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AddTOPlayListRecent obj) {
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
      other is AddTOPlayListRecentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

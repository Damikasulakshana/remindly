// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'special_date.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpecialDateAdapter extends TypeAdapter<SpecialDate> {
  @override
  final int typeId = 0;

  @override
  SpecialDate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpecialDate(
      name: fields[0] as String,
      date: fields[1] as DateTime,
      type: fields[2] as String,
      notes: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SpecialDate obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecialDateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

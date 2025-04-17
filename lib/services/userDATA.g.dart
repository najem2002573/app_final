// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userDATA.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserdataAdapter extends TypeAdapter<Userdata> {
  @override
  final int typeId = 3;

  @override
  Userdata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Userdata(
      uid: fields[0] as String,
      age: fields[1] as int,
      goal: fields[2] as String,
      gender: fields[3] as String,
      height: fields[4] as double,
      weight: fields[5] as double,
      activityLevel: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Userdata obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.goal)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.weight)
      ..writeByte(6)
      ..write(obj.activityLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserdataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrients.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NutrientsAdapter extends TypeAdapter<Nutrients> {
  @override
  final int typeId = 0;

  @override
  Nutrients read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Nutrients()
      ..protein = fields[4] as double
      ..carbs = fields[0] as double
      ..fats = fields[2] as double
      ..sugars = fields[1] as double
      ..calories = fields[3] as double
      ..waterGlasses = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, Nutrients obj) {
    writer
      ..writeByte(6)
      ..writeByte(4)
      ..write(obj.protein)
      ..writeByte(0)
      ..write(obj.carbs)
      ..writeByte(2)
      ..write(obj.fats)
      ..writeByte(1)
      ..write(obj.sugars)
      ..writeByte(3)
      ..write(obj.calories)
      ..writeByte(5)
      ..write(obj.waterGlasses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutrientsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perk_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PerkModelAdapter extends TypeAdapter<PerkModel> {
  @override
  final int typeId = 0;

  @override
  PerkModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PerkModel(
      name: fields[0] as String,
      source: fields[1] as String,
      cost: fields[2] as String,
      description: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PerkModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.source)
      ..writeByte(2)
      ..write(obj.cost)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PerkModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

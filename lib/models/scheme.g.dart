// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheme.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchemeAdapter extends TypeAdapter<Scheme> {
  @override
  final int typeId = 0;

  @override
  Scheme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Scheme(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      translatedNames: (fields[3] as Map).cast<String, String>(),
      translatedDescriptions: (fields[4] as Map).cast<String, String>(),
      rules: (fields[5] as Map).cast<String, dynamic>(),
      requiredDocuments: (fields[6] as List).cast<String>(),
      applicationUrl: fields[7] as String,
      benefitAmount: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Scheme obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.translatedNames)
      ..writeByte(4)
      ..write(obj.translatedDescriptions)
      ..writeByte(5)
      ..write(obj.rules)
      ..writeByte(6)
      ..write(obj.requiredDocuments)
      ..writeByte(7)
      ..write(obj.applicationUrl)
      ..writeByte(8)
      ..write(obj.benefitAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

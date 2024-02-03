// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temporary_storage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TemporaryStorageAdapter extends TypeAdapter<TemporaryStorage> {
  @override
  final int typeId = 1;

  @override
  TemporaryStorage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TemporaryStorage(
      serialNumber: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TemporaryStorage obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.serialNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemporaryStorageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_recording_file_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CallRecordingHiveModelAdapter
    extends TypeAdapter<CallRecordingHiveModel> {
  @override
  final int typeId = 0;

  @override
  CallRecordingHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CallRecordingHiveModel(
      filePath: fields[0] as String?,
      timestamp: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CallRecordingHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.filePath)
      ..writeByte(1)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallRecordingHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

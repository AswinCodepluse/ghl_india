import 'package:hive/hive.dart';

part 'call_recording_file_hive_model.g.dart';

@HiveType(typeId: 0)
class CallRecordingHiveModel{
  @HiveField(0)
  String? filePath;

  @HiveField(1)
  DateTime? timestamp;

  CallRecordingHiveModel({required this.filePath, required this.timestamp});
}

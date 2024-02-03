import 'package:hive/hive.dart';
part 'temporary_storage.g.dart';

@HiveType(typeId: 1)
class TemporaryStorage {
  @HiveField(0)
  final String serialNumber;
  TemporaryStorage({
    required this.serialNumber
  });
}
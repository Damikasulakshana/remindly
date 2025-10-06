import 'package:hive_flutter/hive_flutter.dart';

part 'special_date.g.dart';

@HiveType(typeId: 0)
class SpecialDate extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  DateTime date; // Stored as milliseconds since epoch

  @HiveField(2)
  String type; // e.g., 'Birthday', 'Anniversary'

  @HiveField(3)
  String? notes;

  SpecialDate({
    required this.name,
    required this.date,
    required this.type,
    this.notes,
  });
}

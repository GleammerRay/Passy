import 'package:passy/passy_data/csv_convertable.dart';

import 'entry_event.dart';

abstract class PassyFsMeta with CSVConvertable {
  final String key;
  final String name;
  EntryStatus status;
  DateTime entryModified;

  PassyFsMeta({
    String? key,
    required this.name,
    required this.status,
    DateTime? entryModified,
  })  : key = key ??
            DateTime.now().toUtc().toIso8601String().replaceAll(':', 'c'),
        entryModified = entryModified ?? DateTime.now().toUtc();
}

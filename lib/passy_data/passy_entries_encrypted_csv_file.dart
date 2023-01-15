import 'package:encrypt/encrypt.dart';
import 'package:passy/passy_data/common.dart';
import 'package:passy/passy_data/entry_type.dart';
import 'package:passy/passy_data/passy_entry.dart';
import 'package:passy/passy_data/saveable_file_base.dart';
import 'dart:io';

import 'passy_entries.dart';

class PassyEntriesEncryptedCSVFile<T extends PassyEntry<T>>
    with SaveableFileBase {
  final File _file;
  final PassyEntries<T> value;
  Encrypter _encrypter;
  set encrypter(Encrypter encrypter) => _encrypter = encrypter;

  PassyEntriesEncryptedCSVFile(
    this._file, {
    required Encrypter encrypter,
    required this.value,
  }) : _encrypter = encrypter;

  factory PassyEntriesEncryptedCSVFile.fromFile(
    File file, {
    required Encrypter encrypter,
  }) {
    if (file.existsSync()) {
      Map<String, T> _entries = {};
      RandomAccessFile _file = file.openSync();
      bool eofReached = false;
      do {
        String line = readLine(_file, onEOF: () => eofReached = true) ?? '';
        if (line == '') continue;
        List<dynamic> _decoded1 = csvDecode(line);
        List<dynamic> _decoded2 = csvDecode(
            decrypt(_decoded1[1], encrypter: encrypter),
            recursive: true);
        _entries[_decoded1[0]] =
            (PassyEntry.fromCSV(entryTypeFromType(T)!)(_decoded2) as T);
      } while (eofReached == false);
      return PassyEntriesEncryptedCSVFile<T>(
        file,
        encrypter: encrypter,
        value: PassyEntries<T>(entries: _entries),
      );
    }
    file.createSync(recursive: true);
    PassyEntriesEncryptedCSVFile<T> _file = PassyEntriesEncryptedCSVFile<T>(
        file,
        encrypter: encrypter,
        value: PassyEntries<T>());
    _file.saveSync();
    return _file;
  }

  String _save() {
    String _result = '';
    for (List _value in value.toCSV()) {
      String _key = _value[0];
      _result += '$_key,${encrypt(csvEncode(_value), encrypter: _encrypter)}\n';
    }
    return _result;
  }

  @override
  Future<void> save() => _file.writeAsString(_save());

  @override
  void saveSync() => _file.writeAsStringSync(_save());
}

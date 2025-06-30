import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';

/// Generates `en.json`, `mr.json`, and `hi.json` from an Excel
/// localisation sheet.
///
/// The sheet must have exactly four columns in this order:
///   0: key
///   1: English value
///   2: Marathi value
///   3: Hindi value
///
/// [excelPath]  – full path to the `.xlsx` file
/// [outputDir]  – folder where the JSON files will be written
///
/// Throws [FileSystemException] if paths are invalid, and
/// generic [Exception] on format errors.
Future<void> buildLocaleJsons({
  required String excelPath,
  required String outputDir,
  required int sheetIndex,
}) async {
  // ---------- 1. Load workbook ----------
  final file = File(excelPath);
  if (!await file.exists()) {
    throw FileSystemException('Excel file not found', excelPath);
  }
  final bytes = await file.readAsBytes();
  final excel = Excel.decodeBytes(bytes);

  if (excel.tables.isEmpty) {
    throw Exception('Excel file contains no sheets.');
  }

  final sheet = excel.tables.values.elementAt(sheetIndex); // 0‑based index → second sheet

  // ---------- 2. Prepare language maps ----------
  final Map<String, String> en = {};
  final Map<String, String> mr = {};
  final Map<String, String> hi = {};

  // Skip header row (assumed index 0)
  for (var rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
    final List<Data?> row = sheet.row(rowIndex);

    if (row.length < 4) {
      throw Exception('Row $rowIndex has fewer than 4 columns.');
    }

    final key = row[0]?.value?.toString().trim();
    if (key == null || key.isEmpty) continue; // ignore blank keys

    en[key] = row[1]?.value?.toString().trim() ?? '';
    mr[key] = row[2]?.value?.toString().trim() ?? '';
    hi[key] = row[3]?.value?.toString().trim() ?? '';
  }

  // ---------- 3. Write pretty‑printed JSON files ----------
  final outDir = Directory(outputDir)..createSync(recursive: true);

  Future<void> _write(String fileName, Map<String, String> map) async {
    final jsonStr = const JsonEncoder.withIndent('  ').convert(map);
    final path = '${outDir.path}/$fileName';
    await File(path).writeAsString(jsonStr);
    print('✓ Wrote $path (${map.length} keys)');
  }

  await _write('en.json', en);
  await _write('mr.json', mr);
  await _write('hi.json', hi);
}

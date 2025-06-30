import 'package:excel/excel.dart';   // 4.0.6

/// Scans [sheetName] and returns the addresses (e.g. `A2`, `A7`)
/// of all cells that contain duplicate values in the zero‑based
/// [column] (`0` = column A, `1` = column B, …).
///
/// Empty cells and cells that evaluate to an empty string are ignored.
List<String> findDuplicateCellsInColumn({
  required Excel excel,
  required String sheetName,
  required int column,
}) {
  final Sheet? sheet = excel.tables[sheetName];
  if (sheet == null) {
    throw ArgumentError('Sheet "$sheetName" not found.');
  }

  // Map: cell‑text → list of row indices where that text appears
  final Map<String, List<int>> occurrences = {};

  for (int row = 0; row < sheet.rows.length; row++) {
    final data =
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row));

    final cellValue = data.value; // CellValue? (sealed class hierarchy)

    if (cellValue == null) continue;

    // Convert to a comparable string; trim if it's really text
    final key = cellValue.toString().trim();
    if (key.isEmpty) continue;

    occurrences.putIfAbsent(key, () => []).add(row);
  }

  // Collect duplicates
  final List<String> duplicates = [];
  occurrences.forEach((_, rows) {
    if (rows.length > 1) {
      for (final r in rows) {
        // Use helper from the excel package to convert column index → letters
        duplicates.add('${getColumnAlphabet(column)}${r + 1}');
      }
    }
  });

  return duplicates;
}

import 'dart:io';
import 'package:crud_excel/crud_excel.dart';
import 'package:excel/excel.dart';

void main() {
  final bytes = File('assets/localizations.xlsx').readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);

  final dupes = findDuplicateCellsInColumn(
    excel: excel,
    sheetName: 'others',
    column: 0, // Column A
  );

  if (dupes.isEmpty) {
    print('No duplicates found.');
  } else {
    print('Duplicate cells: ${dupes.join(", ")}');
  }
}

import 'dart:io';
import 'package:crud_excel/build_locales.dart';
import 'package:crud_excel/crud_excel.dart';
import 'package:excel/excel.dart';


void main() async {
  try {
    await buildLocaleJsons(
      excelPath: 'assets/localizations.xlsx',
      outputDir: 'assets/localizations',
      sheetIndex: 1
    );
    print('Locale JSON files generated successfully.');
  } catch (e) {
    print('Error: $e');
  }
}

// void main() {
//   final bytes = File('assets/localizations.xlsx').readAsBytesSync();
//   final excel = Excel.decodeBytes(bytes);

//   final dupes = findDuplicateCellsInColumn(
//     excel: excel,
//     sheetName: 'others',
//     column: 0, // Column A
//   );

//   if (dupes.isEmpty) {
//     print('No duplicates found.');
//   } else {
//     print('Duplicate cells: ${dupes.join(", ")}');
//   }
// }

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:digital_dairy/core/logger/logger.dart';
import 'package:digital_dairy/features/milklog/model/milk_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

///
class MilkPdfService {
  ///
  Future<File?> generateAndSaveMilkPdf({
    required List<MilkModel> logs,
    required String cattleName,
    required String cattleId,
    required DateTime selectedMonth,
  }) async {
    try {
      if (!await _requestStoragePermission()) {
        throw Exception('Storage permission denied');
      }

      final pw.Document pdf = await _generateMilkPdf(
        logs: logs,
        cattleName: cattleName,
        cattleId: cattleId,
        selectedMonth: selectedMonth,
      );

      final File file = await _savePdfToDevice(pdf, cattleName, selectedMonth);
      return file;
    } catch (e) {
      logInfo('Error generating PDF: $e');
      return null;
    }
  }

  Future<pw.Document> _generateMilkPdf({
    required List<MilkModel> logs,
    required String cattleName,
    required String cattleId,
    required DateTime selectedMonth,
  }) async {
    final pw.Document pdf = pw.Document();

    final double totalMilk = logs.fold(
      0,
      (double sum, MilkModel m) => sum + m.quantityInLiter,
    );

    double morningMilk = 0;
    double eveningMilk = 0;
    for (final MilkModel log in logs) {
      final String shiftValue = log.shift.value.toLowerCase();
      if (shiftValue == 'morning') {
        morningMilk += log.quantityInLiter;
      } else if (shiftValue == 'evening') {
        eveningMilk += log.quantityInLiter;
      }
    }

    final double avgMilk = logs.isNotEmpty ? totalMilk / logs.length : 0;
    final int daysRecorded = logs
        .map((MilkModel m) => m.date.day)
        .toSet()
        .length;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => <pw.Widget>[
          _buildHeader(cattleName, cattleId, selectedMonth),
          pw.SizedBox(height: 20),
          _buildSummary(
            totalMilk,
            avgMilk,
            daysRecorded,
            morningMilk,
            eveningMilk,
          ),
          pw.SizedBox(height: 24),
          _buildMilkTable(logs),
          pw.SizedBox(height: 30),
          _buildFooter(),
        ],
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(String cattleName, String cattleId, DateTime month) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: <pw.Widget>[
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Text(
                    'MILK PRODUCTION REPORT',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    DateFormat('MMMM yyyy').format(month),
                    style: const pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: <pw.Widget>[
                  pw.Text(
                    'Generated on',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                    ),
                  ),
                  pw.Text(
                    DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Divider(thickness: 2),
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.blue200),
            ),
            child: pw.Row(
              children: <pw.Widget>[
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Text(
                        'Cattle Details',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey700,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        cattleName,
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'ID: $cattleId',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  pw.Widget _buildSummary(
    double totalMilk,
    double avgMilk,
    int daysRecorded,
    double morningMilk,
    double eveningMilk,
  ) => pw.Column(
    children: <pw.Widget>[
      // First row - Total and Average
      pw.Row(
        children: <pw.Widget>[
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: PdfColors.blue300),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Text(
                    'Total Production',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '${totalMilk.toStringAsFixed(1)} L',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          pw.SizedBox(width: 12),
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.teal50,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: PdfColors.teal300),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Text(
                    'Daily Average',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '${avgMilk.toStringAsFixed(1)} L',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.teal900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          pw.SizedBox(width: 12),
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.purple50,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: PdfColors.purple300),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Text(
                    'Days Recorded',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '$daysRecorded',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.purple900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      pw.SizedBox(height: 12),
      // Second row - Morning and Evening
      pw.Row(
        children: <pw.Widget>[
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.orange50,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: PdfColors.orange300),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Text(
                    'Morning Shift',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '${morningMilk.toStringAsFixed(1)} L',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.orange900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          pw.SizedBox(width: 12),
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.indigo50,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: PdfColors.indigo300),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Text(
                    'Evening Shift',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '${eveningMilk.toStringAsFixed(1)} L',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.indigo900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );

  pw.Widget _buildMilkTable(List<MilkModel> logs) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: <pw.Widget>[
      pw.Text(
        'Daily Production Records',
        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 12),
      pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey300),
        columnWidths: <int, pw.TableColumnWidth>{
          0: const pw.FlexColumnWidth(2),
          1: const pw.FlexColumnWidth(1.5),
          2: const pw.FlexColumnWidth(1.5),
          3: const pw.FlexColumnWidth(3),
        },
        children: <pw.TableRow>[
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: PdfColors.grey200),
            children: <pw.Widget>[
              _buildTableCell('Date', isHeader: true),
              _buildTableCell('Shift', isHeader: true),
              _buildTableCell('Quantity (L)', isHeader: true),
              _buildTableCell('Notes', isHeader: true),
            ],
          ),
          ...logs.map(
            (MilkModel milk) => pw.TableRow(
              children: <pw.Widget>[
                _buildTableCell(DateFormat('dd MMM yyyy').format(milk.date)),
                _buildTableCell(
                  milk.shift.value.toLowerCase() == 'morning'
                      ? 'Morning'
                      : 'Evening',
                ),
                _buildTableCell(milk.quantityInLiter.toStringAsFixed(1)),
                _buildTableCell(milk.notes.isNotEmpty ? milk.notes : '-'),
              ],
            ),
          ),
        ],
      ),
    ],
  );

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) => pw.Padding(
    padding: const pw.EdgeInsets.all(8),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: isHeader ? 10 : 9,
        fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        color: isHeader ? PdfColors.grey800 : PdfColors.black,
      ),
    ),
  );

  pw.Widget _buildFooter() => pw.Column(
    children: <pw.Widget>[
      pw.Divider(),
      pw.SizedBox(height: 8),
      pw.Text(
        'This is a computer-generated document. No signature required.',
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
        textAlign: pw.TextAlign.center,
      ),
    ],
  );

  Future<File> _savePdfToDevice(
    pw.Document pdf,
    String cattleName,
    DateTime month,
  ) async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final String fileName =
        'Milk_${cattleName.replaceAll(' ', '_')}_${DateFormat('MMM_yyyy').format(month)}.pdf';
    final String filePath = '${directory!.path}/$fileName';

    final File file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo =
          await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        return true;
      } else {
        final PermissionStatus status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    return true;
  }

  ///
  Future<void> previewPdf({
    required List<MilkModel> logs,
    required String cattleName,
    required String cattleId,
    required DateTime selectedMonth,
  }) async {
    final pw.Document pdf = await _generateMilkPdf(
      logs: logs,
      cattleName: cattleName,
      cattleId: cattleId,
      selectedMonth: selectedMonth,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  ///
  Future<void> sharePdf({
    required List<MilkModel> logs,
    required String cattleName,
    required String cattleId,
    required DateTime selectedMonth,
  }) async {
    final pw.Document pdf = await _generateMilkPdf(
      logs: logs,
      cattleName: cattleName,
      cattleId: cattleId,
      selectedMonth: selectedMonth,
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename:
          'Milk_${cattleName.replaceAll(' ', '_')}_${DateFormat('MMM_yyyy').format(selectedMonth)}.pdf',
    );
  }
}

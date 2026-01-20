import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:digital_dairy/core/logger/logger.dart';
import 'package:digital_dairy/features/sales/model/milk_sales_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

///
class SalesPdfService {
  ///
  Future<File?> generateAndSaveSalesPdf({
    required List<MilkSale> sales,
    required String buyerName,
    required String buyerId,
    required DateTime selectedMonth,
  }) async {
    try {
      if (!await _requestStoragePermission()) {
        throw Exception('Storage permission denied');
      }

      final pw.Document pdf = await _generateSalesPdf(
        sales: sales,
        buyerName: buyerName,
        buyerId: buyerId,
        selectedMonth: selectedMonth,
      );

      final File file = await _savePdfToDevice(pdf, buyerName, selectedMonth);
      return file;
    } catch (e) {
      logInfo('Error generating PDF: $e');
      return null;
    }
  }

  Future<pw.Document> _generateSalesPdf({
    required List<MilkSale> sales,
    required String buyerName,
    required String buyerId,
    required DateTime selectedMonth,
  }) async {
    final pw.Document pdf = pw.Document();

    final double totalQuantity = sales.fold(
      0,
      (double sum, MilkSale sale) => sum + sale.quantityLitres,
    );
    final double totalAmount = sales.fold(
      0,
      (double sum, MilkSale sale) => sum + (sale.totalAmount ?? 0.0),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => <pw.Widget>[
          _buildHeader(buyerName, buyerId, selectedMonth),
          pw.SizedBox(height: 20),
          _buildSummary(totalQuantity, totalAmount),
          pw.SizedBox(height: 24),
          _buildSalesTable(sales),
          pw.SizedBox(height: 30),
          _buildFooter(),
        ],
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(String buyerName, String buyerId, DateTime month) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'SALES REPORT',
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
                children: [
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
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Buyer Details',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey700,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        buyerName,
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'ID: $buyerId',
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

  pw.Widget _buildSummary(double totalQuantity, double totalAmount) => pw.Row(
    children: [
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
            children: [
              pw.Text(
                'Total Quantity',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '${totalQuantity.toStringAsFixed(1)} L',
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
      pw.SizedBox(width: 16),
      pw.Expanded(
        child: pw.Container(
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: PdfColors.green50,
            borderRadius: pw.BorderRadius.circular(8),
            border: pw.Border.all(color: PdfColors.green300),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Total Amount',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Rs. ${totalAmount.toStringAsFixed(2)}',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green900,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  pw.Widget _buildSalesTable(List<MilkSale> sales) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: <pw.Widget>[
      pw.Text(
        'Transaction Details',
        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 12),
      pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey300),
        children: <pw.TableRow>[
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: PdfColors.grey200),
            children: <pw.Widget>[
              _buildTableCell('Date', isHeader: true),
              _buildTableCell('Quantity (L)', isHeader: true),
              _buildTableCell('Price/L', isHeader: true),
              _buildTableCell('Total Amount', isHeader: true),
            ],
          ),
          ...sales.map(
            (MilkSale sale) => pw.TableRow(
              children: [
                _buildTableCell(DateFormat('dd MMM yyyy').format(sale.date)),
                _buildTableCell(sale.quantityLitres.toStringAsFixed(1)),
                _buildTableCell('Rs. ${sale.pricePerLitre.toStringAsFixed(2)}'),
                _buildTableCell(
                  '₹${(sale.totalAmount ?? 0.0).toStringAsFixed(2)}',
                ),
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
    children: [
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
    String buyerName,
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
        'Sales_${buyerName.replaceAll(' ', '_')}_${DateFormat('MMM_yyyy').format(month)}.pdf';
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

  Future<void> previewPdf({
    required List<MilkSale> sales,
    required String buyerName,
    required String buyerId,
    required DateTime selectedMonth,
  }) async {
    final pw.Document pdf = await _generateSalesPdf(
      sales: sales,
      buyerName: buyerName,
      buyerId: buyerId,
      selectedMonth: selectedMonth,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> sharePdf({
    required List<MilkSale> sales,
    required String buyerName,
    required String buyerId,
    required DateTime selectedMonth,
  }) async {
    final pw.Document pdf = await _generateSalesPdf(
      sales: sales,
      buyerName: buyerName,
      buyerId: buyerId,
      selectedMonth: selectedMonth,
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename:
          'Sales_${buyerName.replaceAll(' ', '_')}_${DateFormat('MMM_yyyy').format(selectedMonth)}.pdf',
    );
  }
}

import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:MobileApp_LVTN/models/emp_invoice.dart';


Future<Uint8List> buildPdf(PdfPageFormat pageFormat, EmpInvoice empInvoice) async {
  // Create a PDF document.
  final doc = pw.Document();

  // Add page to the PDF
  doc.addPage(
    pw.MultiPage(
      pageTheme: _buildTheme(
        pageFormat,
        await PdfGoogleFonts.robotoRegular(),
        await PdfGoogleFonts.robotoBold(),
        await PdfGoogleFonts.robotoItalic(),
      ),
      build: (context) => [
        pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Center(
                  child: pw.Text("Hoá đơn tháng ${empInvoice.thang}", style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold))),
            ), // Title hoá đơn
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Mã số phiếu:", style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 5),
                  pw.Text(empInvoice.maSoPhieu, style: const pw.TextStyle(fontSize: 25)),
                ],
              ),
            ), // Mã số phiếu
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Mã khách hàng:", style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 5),
                  pw.Text(empInvoice.maKhachHang, style: const pw.TextStyle(fontSize: 25)),
                ],
              ),
            ), // Mã khách hàng
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Tên khách hàng:", style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 5),
                  pw.Text(empInvoice.hoTenKH, style: const pw.TextStyle(fontSize: 25)),
                ],
              ),
            ), // Tên khách hàng
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Loại khách hàng:", style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 5),
                  pw.Text(empInvoice.tenLoai, style: const pw.TextStyle(fontSize: 25)),
                ],
              ),
            ), // Loại khách hàng
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Địa chỉ:",style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 5),
                  pw.Flexible(child: pw.Text(empInvoice.diaChiKH,style: const pw.TextStyle(fontSize: 25))),
                ],
              ),
            ), // Địa chỉ khách hàng
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Ngày tạo hoá đơn:",style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 5),
                  pw.Text(empInvoice.ngayTao,style: pw.TextStyle(fontSize: 25)),
                ],
              ),
            ), // Ngày tạo
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Ngày thu:", style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 5),
                  pw.Text(empInvoice.ngayThu,style: const pw.TextStyle(fontSize: 25))
                ],
              ),
            ), // Ngày thu
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Giá:", style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 5),
                  pw.Text("${empInvoice.gia.toString()}đ", style: const pw.TextStyle(fontSize: 25)),
                ],
              ),
            )
          ],
        )
      ],
    ),
  );

  // Return the PDF file content
  return doc.save();
}

pw.PageTheme _buildTheme(
    PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
  return pw.PageTheme(
    pageFormat: pageFormat,
    theme: pw.ThemeData.withFont(
      base: base,
      bold: bold,
      italic: italic,
    )
  );
}
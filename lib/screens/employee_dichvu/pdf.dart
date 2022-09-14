import 'dart:typed_data';
import 'package:MobileApp_LVTN/models/chitiet_dichvu.dart';
import 'package:MobileApp_LVTN/models/donhang.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


final pw.TextStyle headerStyle = pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold);
final pw.TextStyle contentStyle = pw.TextStyle(fontSize: 20);
final pw.TextStyle tableHeaderStyle = pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold);
final pw.TextStyle tableRowStyle = pw.TextStyle(fontSize: 14);

Future<Uint8List> buildPdfOrder(PdfPageFormat pageFormat, DonHang donHang, List<ChiTietDichVu> dichVuList) async {
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
              padding: const pw.EdgeInsets.all(5),
              child: pw.Center(
                  child: pw.Text("Đơn hàng ${donHang.maDonHang}", style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold))),
            ), // Title đơn hàng
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text(
                    "Tên khách hàng",
                    style: headerStyle,
                  ),
                  pw.SizedBox(width: 5),
                  pw.Text(donHang.tenKhachHang, style: contentStyle),
                ],
              ),
            ), // Tên khách hàng
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Địa chỉ:", style: headerStyle),
                  pw.SizedBox(width: 5),
                  pw.Flexible(
                      child: pw.Text(donHang.diaChiKh, style: contentStyle)),
                ],
              ),
            ), // Địa chỉ khách hàng
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Số điện thoại:", style: headerStyle),
                  pw.SizedBox(width: 5),
                  pw.Text(donHang.soDienThoaiKh, style: contentStyle),
                ],
              ),
            ), // Số điện thoại KH
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Ngày thu:", style: headerStyle),
                  pw.SizedBox(width: 5),
                  pw.Text(donHang.ngayThu, style: contentStyle)
                ],
              ),
            ), // Ngày thu
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Nhân viên thu:", style: headerStyle),
                  pw.SizedBox(width: 5),
                  pw.Text(donHang.hoTen, style: contentStyle)
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Số điện thoại nhân viên:", style: headerStyle),
                  pw.SizedBox(width: 5),
                  pw.Text(donHang.soDienThoai, style: contentStyle)
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 5.0, right: 5.0, bottom: 15.0, top: 10.0),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.only(right: 5.0),
                    width: 195,
                    child: pw.Center(child: pw.Text("Tên dịch vụ", style: tableHeaderStyle)),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.only(right: 5.0),
                    width: 90,
                    child: pw.Center(child: pw.Text("Số lượng", style: tableHeaderStyle)),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.only(right: 5.0),
                    width: 90,
                    child: pw.Center(child: pw.Text("Đơn giá", style: tableHeaderStyle)),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.only(right: 5.0),
                    width: 90,
                    child: pw.Center(child: pw.Text("Tổng", style: tableHeaderStyle)),
                  ),
                ],
              ),
            ),
            buildServiceList(dichVuList),
            pw.Padding(
              padding: const pw.EdgeInsets.only(right: 50, bottom: 20),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text("Tổng tiền: ", style: headerStyle),
                  pw.Text("${donHang.tongTienDh}đ", style: contentStyle),
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

buildServiceList(List<ChiTietDichVu> dichVuList){
  return pw.ListView.builder(
    itemCount: dichVuList.length,
    itemBuilder: (pw.Context context, int index){
      return pw.Padding(
        padding: const pw.EdgeInsets.only(left: 8.0, right: 5.0, bottom: 15.0),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.only(right: 5.0),
              width: 195,
              child: pw.Center(child: pw.Text(dichVuList[index].tenDichVu, style: tableRowStyle)),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.only(right: 5.0),
              width: 90,
              child: pw.Center(child: pw.Text(dichVuList[index].soLuong.toString(), style: tableRowStyle),
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.only(right: 5.0),
              width: 90,
              child: pw.Center(child: pw.Text(dichVuList[index].donGia.toString(), style: tableRowStyle)),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.only(right: 5.0),
              width: 90,
              child: pw.Center(child: pw.Text(dichVuList[index].tongTienDv.toString(), style: tableRowStyle)),
            ),
          ],
        ),
      );
    }
  );
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
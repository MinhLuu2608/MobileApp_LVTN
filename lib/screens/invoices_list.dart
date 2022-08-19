import 'package:MobileApp_LVTN/widgets/expansion_list.dart';
import 'package:flutter/material.dart';

class InvoicesList extends StatefulWidget{
  const InvoicesList({Key? key}) : super(key: key);

  @override
  InvoicesListState createState() => InvoicesListState();
}

class InvoicesListState extends State<InvoicesList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExpansionList(),
    );
  }
}
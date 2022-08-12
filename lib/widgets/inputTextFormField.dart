import 'package:flutter/material.dart';
import 'package:MobileApp_LVTN/widgets/inputDecoration.dart';

class InputTextFormField {
  static TextFormField inputEmailTextFormField(
      {required String hint, required String label, required Icon icon}) {
    return TextFormField(
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecorations.inputDecoration(
          hintText: hint, labelText: label, icon: icon),
      validator: (value) {
        String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
        RegExp regExp = new RegExp(pattern);
        return regExp.hasMatch(value ?? '') ? null : 'Không phải định dạng email';
      },
    );
  }

  static TextFormField inputPasswordTextFormField(
      {required String hint, required String label, required Icon icon}) {
    return TextFormField(
        autocorrect: false,
        obscureText: true,
        validator: (value) {
          return (value != null && value.length >= 6)
              ? null
              : "Password có ít nhất 6 ký tự";
        },
        decoration: InputDecorations.inputDecoration(
            hintText: hint, labelText: label, icon: icon)
    );
  }
}
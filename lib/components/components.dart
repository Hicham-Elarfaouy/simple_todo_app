import 'package:flutter/material.dart';

Widget defaultForm ({
  TextInputType type = TextInputType.text,
  TextEditingController? controller,
  Function(String)? function,
  String? text,
  Icon? icon,
  Function()? onTap,
  String? Function(String?)? validate,
  bool read = false,
}) => TextFormField(
  readOnly: read,
  keyboardType: type,
  controller: controller,
  onFieldSubmitted: function,
  onTap: onTap,
  validator: validate,
  decoration: InputDecoration(
    labelText: text,
    prefixIcon: icon,
    border: OutlineInputBorder(),
  ),
);
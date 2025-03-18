import 'package:flutter/material.dart';

enum ButtonType {
  confirm(Colors.green),
  delete(Colors.red),
  cancel(Colors.grey);

  final MaterialColor color;

  const ButtonType(this.color);
}
import 'package:flutter/material.dart';

void showSnackBarMessage(BuildContext context, String message,
    [isError = false]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : null,
    ),
  );
}
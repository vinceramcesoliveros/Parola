import 'package:flutter/material.dart';

class ListTabResult {
  ListTabResult(
      {@required this.text, @required this.isSuccessful, this.description});

  final String text, description;
  final bool isSuccessful;
}

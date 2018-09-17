import 'package:flutter/material.dart';

class ListTabResult {
  ListTabResult(
      {@required this.text, @required this.isSuccessful, this.distance});

  final String text;
  final double distance;
  final bool isSuccessful;
}

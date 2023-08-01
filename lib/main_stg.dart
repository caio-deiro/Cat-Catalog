import 'package:cat_list/env.dart';
import 'package:cat_list/features/app_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    AppWidget(
      environmentType: Stg(),
    ),
  );
}

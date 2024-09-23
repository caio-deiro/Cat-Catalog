import 'package:cat_list/app/app_widget.dart';
import 'package:cat_list/app/shared/services/gemini_service.dart';
import 'package:cat_list/env.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GeminiService().initGemini;
  runApp(
    AppWidget(
      environmentType: Prod(),
    ),
  );
}

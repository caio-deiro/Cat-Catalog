import 'package:cat_list/app/app_widget.dart';
import 'package:cat_list/app/shared/services/gemini_service.dart';
import 'package:cat_list/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  GeminiService().initGemini;
  runApp(
    AppWidget(
      environmentType: Stg(),
    ),
  );
}

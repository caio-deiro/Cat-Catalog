import 'package:flutter_gemini/flutter_gemini.dart';

final class GeminiService {
  void get initGemini => Gemini.init(
        apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
      );
}

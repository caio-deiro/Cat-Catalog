import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

final class GeminiService {
  void get initGemini => Gemini.init(
        apiKey: dotenv.env['GEMINI_API_KEY']!,
      );
}

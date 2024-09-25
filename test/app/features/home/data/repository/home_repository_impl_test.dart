import 'dart:convert';
import 'dart:io';

import 'package:cat_list/app/features/home/data/models/cat_model.dart';
import 'package:cat_list/app/features/home/data/repository/home_repository_impl.dart';
import 'package:cat_list/app/features/home/interactor/errors/home_error.dart';
import 'package:cat_list/app/features/home/interactor/repository/home_repository.dart';
import 'package:cat_list/app/shared/services/dio_service.dart';
import 'package:cat_list/app/shared/services/gemini_service.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

class MockGeminiService extends Mock implements Gemini {}

class MockFile extends Mock implements File {}

void main() {
  late final MockGeminiService geminiService;
  late final DioService dioService;
  late final HomeRepository homeRepository;
  late final File file;
  late final DioAdapter dioAdapter;

  void createFile() {
    file = File('generated/file.dart')..createSync(recursive: true);
  }

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GeminiService().initGemini;
    geminiService = MockGeminiService();
    dioService = DioService();
    dioAdapter = DioAdapter(dio: dioService);
    homeRepository = HomeRepositoryImpl(
      dio: dioService,
      gemini: geminiService,
    );
    createFile();
  });

  setUp(() {});

  group('deve testar as chamadas para o gemini', () {
    test('deve retornar um cat model do gemini | ', () async {
      when(
        () => geminiService.textAndImage(
          modelName: 'models/gemini-1.5-flash',
          text: any(named: 'text'),
          images: [
            file.readAsBytesSync(),
          ],
        ),
      ).thenAnswer(
        (_) async => Candidates(
          content: Content(
            parts: [
              Parts(
                text: jsonEncode({
                  'id': '566565465',
                  'url': 'https://en.wikipedia.org/wiki/Abyssinian_(cat)',
                  'breeds': [
                    {
                      'name': 'Abyssinian',
                      'description':
                          'The Abyssinian is easy to care for, and a joy to have in your home. They are affectionate cats and love both people and other animals.',
                      'origin': 'Egypt',
                      'life_span': '14 - 15',
                      'temperament': 'Active, Energetic, Independent, Intelligent, Gentle',
                      'adaptability': 5,
                      'affection_level': 5,
                      'child_friendly': 3,
                      'dog_friendly': 4,
                      'energy_level': 5,
                      'intelligence': 5,
                      'stranger_friendly': 5,
                    }
                  ],
                }),
              ),
            ],
          ),
        ),
      );

      final response = await homeRepository.getCatInfoByPicture(imagePath: file.path);

      final result = response.getOrThrow();

      expect(result, isA<CatModel>());
    });

    test('deve retornar um erro com a messagem "I can\'t see a cat in this picture" | ', () async {
      when(
        () => geminiService.textAndImage(
          modelName: 'models/gemini-1.5-flash',
          text: any(named: 'text'),
          images: [
            file.readAsBytesSync(),
          ],
        ),
      ).thenAnswer(
        (_) async => Candidates(
          content: Content(
            parts: [
              Parts(
                text: 'null',
              ),
            ],
          ),
        ),
      );
      final response = await homeRepository.getCatInfoByPicture(imagePath: file.path);

      final result = response.exceptionOrNull();

      expect(result, isA<HomeErrorsGemini>());
      expect(result?.message, "I can't see a cat in this picture");
    });
  });

  group('deve testar a chamada para pegar os gatos da api', () {
    test('deve retornar uma lista de CatModel | ', () async {
      dioAdapter.onGet(
        'https://api.thecatapi.com/v1/images/search',
        (request) => request.reply(200, [
          {
            'id': '1',
            'url': 'https://en.wikipedia.org/wiki/Abyssinian_(cat)',
            'breeds': [
              {
                'name': 'Abyssinian',
                'description':
                    'The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.',
                'origin': 'Egypt',
                'life_span': '14 - 15',
                'temperament': 'Active, Energetic, Independent, Intelligent, Gentle',
                'adaptability': 5,
                'affection_level': 5,
                'child_friendly': 3,
                'dog_friendly': 4,
                'energy_level': 5,
                'intelligence': 5,
                'stranger_friendly': 5,
              }
            ],
          },
        ]),
      );

      final response = await homeRepository.fetchData(1);
      final result = response.getOrThrow();

      expect(result, isA<List<CatModel>>());
      expect(result.length, equals(1));
      expect(result.first.id, '1');
    });

    test('deve retornar um Result.error | ', () async {
      dioAdapter.onGet(
        'https://api.thecatapi.com/v1/images/search',
        (request) => request.reply(200, [
          {
            'id': '1',
            'url': 'https://en.wikipedia.org/wiki/Abyssinian_(cat)',
            'breeds': [
              {
                'name': 'Abyssinian',
                'description':
                    'The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.',
                'origin': 'Egypt',
                'life_span': '14 - 15',
                'temperament': 'Active, Energetic, Independent, Intelligent, Gentle',
                'adaptability': 5,
                'affection_level': 5,
                'child_friendly': 3,
                'dog_friendly': 4,
                'energy_level': 5,
                'intelligence': 5,
                'stranger_friendly': 5,
              }
            ],
          },
        ]),
      );

      final response = await homeRepository.fetchData(1);
      final result = response.getOrThrow();

      expect(result, isA<List<CatModel>>());
      expect(result.length, equals(1));
    });
  });
}

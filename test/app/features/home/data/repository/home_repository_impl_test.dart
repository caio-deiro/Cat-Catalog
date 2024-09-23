import 'dart:io';

import 'package:cat_list/app/features/home/data/repository/home_repository_impl.dart';
import 'package:cat_list/app/features/home/interactor/bloc/home_bloc.dart';
import 'package:cat_list/app/features/home/interactor/repository/home_repository.dart';
import 'package:cat_list/app/shared/services/dio_service.dart';
import 'package:cat_list/app/shared/services/gemini_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockGeminiService extends Mock implements Gemini {}

class MockDioService extends Mock implements DioService {}

class MockImagePicker extends Mock implements ImagePicker {}

class MockFile extends Mock implements File {}

void main() {
  final homeState = HomeState.initial();
  late final MockGeminiService geminiService;
  late final DioService dioService;
  late final HomeRepository homeRepository;
  late final ImagePicker picker;
  late final File file;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GeminiService().initGemini;
    geminiService = MockGeminiService();
    dioService = MockDioService();
    picker = MockImagePicker();
    file = MockFile();
    homeRepository = HomeRepositoryImpl(
      dio: dioService,
      picker: picker,
      homeState: homeState,
    );
  });

  group('deve testar as chamadas para o gemini | ', () {
    test('deve retornar um erro quando o resultado ser null', () async {
      final uIntList = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
      when(() => file.readAsBytesSync()).thenReturn(uIntList);

      when(() => picker.pickImage(source: ImageSource.gallery)).thenAnswer((_) async => XFile(any()));

      when(
        () => geminiService.textAndImage(
          modelName: any(named: 'modelName'),
          text: any(named: 'text'),
          images: [
            // file.readAsBytesSync(),
          ],
        ),
      ).thenAnswer((_) async => null);

      await homeRepository.getCatInfoByPicture();

      verify(
        () => geminiService.textAndImage(
          modelName: any(named: 'modelName'),
          text: any(named: 'text'),
          images: any(named: 'image'),
        ),
      ).called(1);

      expect(homeState.status, HomeStateStatus.errorGemini);
      expect(homeState.errorMessage, "I can't see a cat in this picture");
    });
  });
}

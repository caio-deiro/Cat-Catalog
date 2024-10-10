import 'package:bloc_test/bloc_test.dart';
import 'package:cat_list/app/features/home/data/models/cat_model.dart';
import 'package:cat_list/app/features/home/interactor/bloc/home_bloc.dart';
import 'package:cat_list/app/features/home/interactor/errors/home_error.dart';
import 'package:cat_list/app/features/home/interactor/repository/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class HomeRepositoryMock extends Mock implements HomeRepository {}

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  const catModel = CatModel(
    name: 'Abyssinian',
    id: 'abys',
    url: 'https://cdn2.thecatapi.com/images/abys.jpg',
    description:
        'The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.',
    origin: 'Egypt',
    lifeSpan: '14 - 15',
    temperament: 'Active, Energetic, Independent, Intelligent, Gentle',
    adaptability: 5,
    childFriendly: 4,
    dogFriendly: 4,
    energyLevel: 5,
    intelligence: 5,
    strangerFriendly: 5,
    affectionLevel: 5,
  );

  const catModel2 = CatModel(
    name: 'sphynx',
    id: 'sphy',
    url: 'https://cdn2.thecatapi.com/images/sphy.jpg',
    description:
        'The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.',
    origin: 'Egypt',
    lifeSpan: '14 - 15',
    temperament: 'Active, Energetic, Independent, Intelligent, Gentle',
    adaptability: 5,
    childFriendly: 4,
    dogFriendly: 4,
    energyLevel: 5,
    intelligence: 5,
    strangerFriendly: 5,
    affectionLevel: 5,
  );

  late final HomeRepository repository;
  late final ImagePicker picker;
  late final homeBloc = HomeBloc(repository: repository, picker: picker);

  setUpAll(() {
    repository = HomeRepositoryMock();
    picker = MockImagePicker();
  });

  tearDown(() {
    homeBloc.close();
  });

  group('Deve testar as funcoes da camada bloc', () {
    test('Deve buscar os dados e retornar sucesso', () async {
      when(() => repository.fetchData(1)).thenAnswer((_) async => const Success([catModel]));

      final response = await repository.fetchData(1);

      final result = response.getOrThrow();

      expect(result, isA<List<CatModel>>());
      expect(result.length, equals(1));
    });

    test('Deve buscar os dados e retornar erro', () async {
      when(() => repository.fetchData(1)).thenAnswer((_) async => const Success([catModel]));

      final response = await repository.fetchData(1);

      final result = response.getOrThrow();

      expect(result, isA<List<CatModel>>());
      expect(result.length, equals(1));
    });
  });

  group('testando os estados do bloc | ', () {
    blocTest(
      'deve retornar LOADED quando os dados sao buscados | ',
      setUp: () => when(() => repository.fetchData(1)).thenAnswer((_) async => const Success([catModel])),
      build: () => HomeBloc(repository: repository, picker: picker),
      act: (bloc) => bloc.add(HomeEventFetchData()),
      expect: () => [
        HomeState.initial(),
        homeBloc.state.copyWith(status: HomeStateStatus.loaded, list: [catModel], immmutableList: [catModel]),
      ],
    );

    blocTest(
      'deve filtrar e retornar um gato apenas | ',
      seed: () => homeBloc.state.copyWith(status: HomeStateStatus.loaded, immmutableList: [catModel, catModel2]),
      build: () => HomeBloc(repository: repository, picker: picker),
      act: (bloc) => bloc.add(HomeEventFilterCats('Abyssinian')),
      expect: () => [
        homeBloc.state.copyWith(
          status: HomeStateStatus.loaded,
          list: [catModel],
          immmutableList: [catModel, catModel2],
        ),
      ],
    );

    blocTest(
      'deve retornar um aviso de lista vazia | ',
      seed: () => homeBloc.state.copyWith(status: HomeStateStatus.loaded, immmutableList: [catModel, catModel2]),
      build: () => HomeBloc(repository: repository, picker: picker),
      act: (bloc) => bloc.add(HomeEventFilterCats('123123')),
      expect: () => [
        homeBloc.state.copyWith(
          status: HomeStateStatus.filtersEmpty,
          list: [],
          immmutableList: [catModel, catModel2],
          errorMessage: "No cat's found",
        ),
      ],
    );
    blocTest<HomeBloc, HomeState>(
      'deve retornar ERROR quando os dados sao buscados | ',
      setUp: () => when(() => repository.fetchData(1)).thenAnswer((_) async => Failure(HomeErrorsApi('Error'))),
      build: () => HomeBloc(repository: repository, picker: picker),
      act: (bloc) => bloc.add(HomeEventFetchData()),
      expect: () => [
        HomeState.initial(),
        homeBloc.state.copyWith(status: HomeStateStatus.error, errorMessage: 'Error', list: []),
      ],
    );
    blocTest(
      'deve retornar MOREIMAGELOADING quando os dados sao buscados | ',
      setUp: () => when(() => repository.fetchData(1)).thenAnswer((_) async => const Success([catModel])),
      build: () => HomeBloc(repository: repository, picker: picker),
      seed: () => homeBloc.state.copyWith(status: HomeStateStatus.loaded, list: [catModel], immmutableList: [catModel]),
      act: (bloc) => bloc.add(HomeEventFetchData()),
      expect: () => [
        homeBloc.state.copyWith(status: HomeStateStatus.moreImageLoading, list: [catModel], immmutableList: [catModel]),
        homeBloc.state.copyWith(status: HomeStateStatus.loaded, list: [catModel], immmutableList: [catModel]),
      ],
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:cat_list/features/home/data/home_repository_impl.dart';
import 'package:cat_list/features/home/interactor/bloc/home_bloc.dart';
import 'package:cat_list/features/home/interactor/entitie/cat_entitie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRepository extends Mock implements HomeRepositoryImpl {}

void main() {
  final repository = MockHomeRepository();
  final homeBloc = HomeBloc(repository);
  const cat = CatEntitie(
    name: 'name',
    id: 'id',
    url: 'url',
    description: 'description',
    origin: 'origin',
    life_span: 'life_span',
    temperament: 'temperament',
    adaptability: 0,
    child_friendly: 0,
    dog_friendly: 0,
    energy_level: 0,
    intelligence: 0,
    stranger_friendly: 0,
    affection_level: 0,
  );

  tearDown(homeBloc.close);

  group('Should tests all blocks', () {
    blocTest(
      'Should return the right state flow',
      build: () {
        when(repository.fetchData)
            .thenAnswer((_) async => HomeStateLoaded(const [cat]));
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEventFetchData()),
      wait: const Duration(seconds: 1),
      expect: () => [
        isA<HomeStateLoading>(),
        isA<HomeStateLoaded>(),
      ],
    );

    blocTest(
      'Should return a list of cat entitie',
      setUp: () {
        when(repository.fetchData).thenAnswer(
          (_) async => HomeStateLoaded(const [cat]),
        );
      },
      build: () => HomeBloc(repository),
      act: (bloc) => bloc.add(HomeEventFetchData()),
      wait: const Duration(seconds: 1),
      expect: () => [
        HomeStateLoading(),
        HomeStateLoaded(const [cat]),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'Should return error state',
      build: () {
        when(repository.fetchData)
            .thenAnswer((_) async => HomeStateError(message: 'error!'));
        return HomeBloc(repository);
      },
      act: (bloc) => bloc.add(HomeEventFetchData()),
      wait: const Duration(seconds: 1),
      expect: () => [
        HomeStateLoading(),
        HomeStateError(message: 'error!'),
      ],
    );
  });
}

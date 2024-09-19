import 'package:bloc/bloc.dart';
import 'package:cat_list/features/home/interactor/entitie/cat_entitie.dart';
import 'package:cat_list/features/home/interactor/repository/home_repository.dart';
import 'package:cat_list/shared/services/shared_preferences_service.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository repository;

  HomeBloc({
    required this.repository,
  }) : super(HomeState.initial()) {
    on<HomeEventFetchData>(_homeEventFetchData);
    on<HomeEventFilterCats>(_filterCats);
    on<HomeEventGetCatFromGemini>(_getCatFromGemini);
  }
  final sharedPreferencesService = SharedPreferencesService();
  List<CatEntitie> immutableList = <CatEntitie>[];
  int? requestPage;
  static const popupKey = 'showPopup';

  void _filterCats(HomeEventFilterCats event, Emitter emit) {
    if (state.status == HomeStateStatus.loaded) {
      final filterCatList = immutableList
          .where(
            (element) => element.name.toLowerCase().startsWith(
                  event.filter.toLowerCase(),
                ),
          )
          .toList();

      emit(state.copyWith(list: filterCatList));
    }
  }

  Future<void> _homeEventFetchData(
    HomeEventFetchData event,
    Emitter emit,
  ) async {
    if (requestPage == 8) return;

    if (state.status != HomeStateStatus.loading && state.status != HomeStateStatus.error) {
      emit(state.copyWith(status: HomeStateStatus.moreImageLoading));
    } else {
      emit(state.copyWith(status: HomeStateStatus.loading));
    }
    incrementRequestPage();
    final result = await repository.fetchData(requestPage!);
    if (result.status == HomeStateStatus.loaded) {
      final filterList = listWithoutEquals(state.list, result.previousList);
      emit(result.copyWith(list: filterList));
      immutableList = state.list;
    } else {
      emit(result);
    }
  }

  void incrementRequestPage() {
    if ((requestPage ?? 0) < 8 && requestPage != null) {
      requestPage = requestPage! + 1;
    }
    requestPage ??= 1;
  }

  List<CatEntitie> listWithoutEquals(
    List<CatEntitie> firstList,
    List<CatEntitie> secondList,
  ) {
    final listCatNames = <String>[];
    final catMap = <String, CatEntitie>{};

    for (final cat in firstList) {
      if (!listCatNames.contains(cat.name)) {
        catMap[cat.name] = cat;
      }
    }

    for (final cat in secondList) {
      if (!listCatNames.contains(cat.name)) {
        catMap[cat.name] = cat;
      }
    }

    return catMap.values.toList();
  }

  Future<void> setShowPopup() async {
    await sharedPreferencesService.setBool(key: popupKey, value: state.showPopup ?? false);
  }

  bool getShowPopup({bool show = true}) {
    return sharedPreferencesService.getBool(key: popupKey);
  }

  Future<void> _getCatFromGemini(
    HomeEventGetCatFromGemini event,
    Emitter emit,
  ) async {
    emit(state.copyWith(status: HomeStateStatus.loading));
    final result = await repository.getCatInfoByPicture();
    emit(
      state.copyWith(
        catEntitieFromGemini: result.catEntitieFromGemini,
        status: result.status,
        errorMessage: result.errorMessage,
      ),
    );
  }
}

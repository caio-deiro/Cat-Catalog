import 'package:bloc/bloc.dart';
import 'package:cat_list/app/features/home/interactor/entitie/cat_entitie.dart';
import 'package:cat_list/app/features/home/interactor/repository/home_repository.dart';
import 'package:cat_list/app/shared/services/shared_preferences_service.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository repository;
  ImagePicker picker;

  HomeBloc({
    required this.repository,
    required this.picker,
  }) : super(HomeState.initial()) {
    on<HomeEventFetchData>(_homeEventFetchData);
    on<HomeEventFilterCats>(_filterCats);
    on<HomeEventGetCatFromGemini>(_getCatFromGemini);
  }
  final sharedPreferencesService = SharedPreferencesService();
  List<CatEntitie> immutableList = <CatEntitie>[];
  int? requestPage;
  static const popupKey = 'showPopup';

  /// Fetch cats from repository
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

    result.fold((catList) {
      final filterList = listWithoutEquals(state.list, catList);
      emit(state.copyWith(list: filterList, status: HomeStateStatus.loaded));
      immutableList = state.list;
    }, (error) {
      emit(state.copyWith(status: HomeStateStatus.error, errorMessage: error.message));
    });
  }

  /// Get cat from Picture mode
  Future<void> _getCatFromGemini(
    HomeEventGetCatFromGemini event,
    Emitter emit,
  ) async {
    emit(state.copyWith(status: HomeStateStatus.loading));
    final photo = await picker.pickImage(source: ImageSource.camera);
    if (photo == null) {
      emit(state.copyWith(status: HomeStateStatus.loaded));
      return;
    }
    final result = await repository.getCatInfoByPicture(imagePath: photo.path);
    result.fold(
      (catEntitieFromGemini) {
        emit(
          state.copyWith(
            catEntitieFromGemini: catEntitieFromGemini,
            status: HomeStateStatus.geminiLoaded,
          ),
        );
      },
      (error) {
        emit(
          state.copyWith(
            status: HomeStateStatus.errorGemini,
            errorMessage: error.message,
          ),
        );
      },
    );
  }

  /// Filter cats by name
  void _filterCats(HomeEventFilterCats event, Emitter emit) {
    if (state.status != HomeStateStatus.error) {
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

  /// Increment request page to fetch more data
  void incrementRequestPage() {
    if ((requestPage ?? 0) < 8 && requestPage != null) {
      requestPage = requestPage! + 1;
    }
    requestPage ??= 1;
  }

  /// Remove duplicates from list
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
}

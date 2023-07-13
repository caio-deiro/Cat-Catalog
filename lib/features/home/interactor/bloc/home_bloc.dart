import 'package:bloc/bloc.dart';
import 'package:cat_list/features/home/interactor/entitie/cat_entitie.dart';
import 'package:cat_list/features/home/interactor/repository/home_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';
part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository repository;
  HomeBloc(this.repository) : super(HomeStateInitial(const [])) {
    on<HomeEventFetchData>(_homeEventFetchData);
    on<HomeEventFilterCats>(_filterCats);
  }
  List<CatEntitie> immutableList = <CatEntitie>[];

  void _filterCats(HomeEventFilterCats event, Emitter emit) {
    final newState = state;
    if (newState is HomeStateLoaded) {
      final filterCatList = immutableList
          .where(
            (element) =>
                element.name.toLowerCase().contains(event.filter.toLowerCase()),
          )
          .toList();

      emit(HomeStateLoaded(filterCatList));
    }
  }

  Future<void> _homeEventFetchData(
    HomeEventFetchData event,
    Emitter emit,
  ) async {
    emit(HomeStateLoading());
    final result = await repository.fetchData();
    if (result is HomeStateLoaded) {
      final newList = <String>[];
      final catList = <CatEntitie>[];

      for (var i = 0; i < result.list.length; i++) {
        if (!newList.contains(result.list[i].name)) {
          newList.add(result.list[i].name);
          catList.add(result.list[i]);
        }
      }
      immutableList.addAll(catList);
      emit(HomeStateLoaded(catList));
    } else {
      emit(result);
    }
  }
}

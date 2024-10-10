// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

enum HomeStateStatus { loading, moreImageLoading, loaded, error, errorGemini, geminiLoaded, filtersEmpty }

final class HomeState extends Equatable {
  final HomeStateStatus status;
  final List<CatEntitie> list;
  final List<CatEntitie> previousList;
  final List<CatEntitie> immutableList;
  final CatEntitie? catEntitieFromGemini;
  final String? errorMessage;
  final bool? showPopup;

  const HomeState({
    required this.list,
    required this.errorMessage,
    required this.previousList,
    required this.status,
    required this.catEntitieFromGemini,
    required this.showPopup,
    required this.immutableList,
  });

  factory HomeState.initial() {
    return const HomeState(
      list: [],
      errorMessage: '',
      status: HomeStateStatus.loading,
      previousList: [],
      catEntitieFromGemini: null,
      showPopup: null,
      immutableList: [],
    );
  }

  HomeState copyWith({
    List<CatEntitie>? list,
    List<CatEntitie>? previousList,
    int? catRequestEntity,
    String? errorMessage,
    HomeStateStatus? status,
    CatEntitie? catEntitieFromGemini,
    bool? showPopup,
    List<CatEntitie>? immmutableList,
  }) {
    return HomeState(
      list: list ?? this.list,
      previousList: previousList ?? this.previousList,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      catEntitieFromGemini: catEntitieFromGemini ?? this.catEntitieFromGemini,
      showPopup: showPopup ?? this.showPopup,
      immutableList: immmutableList ?? immutableList,
    );
  }

  @override
  List<Object?> get props => [
        list,
        errorMessage,
        status,
        previousList,
        catEntitieFromGemini,
        showPopup,
        immutableList,
      ];
}

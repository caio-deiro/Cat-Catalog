part of 'home_bloc.dart';

sealed class HomeState extends Equatable {}

final class HomeStateInitial extends HomeState {
  // ignore: avoid_unused_constructor_parameters
  HomeStateInitial(List<CatEntitie> list);

  @override
  List<Object?> get props => [];
}

final class HomeStateLoaded extends HomeState {
  final List<CatEntitie> list;
  HomeStateLoaded(this.list);

  @override
  List<Object?> get props => [list];
}

final class HomeStateLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

final class HomeStateError extends HomeState {
  final String message;
  final StackTrace? stk;

  HomeStateError({required this.message, this.stk});

  @override
  List<Object?> get props => [message];
}

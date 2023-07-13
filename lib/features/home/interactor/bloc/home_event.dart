part of 'home_bloc.dart';

sealed class HomeEvent {}

final class HomeEventFetchData extends HomeEvent {}

final class HomeEventFilterCats extends HomeEvent {
  final String filter;

  HomeEventFilterCats(this.filter);
}

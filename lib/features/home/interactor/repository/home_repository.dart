import 'package:cat_list/features/home/interactor/bloc/home_bloc.dart';

abstract class HomeRepository {
  Future<HomeState> fetchData();
}

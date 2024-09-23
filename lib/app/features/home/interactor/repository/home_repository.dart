import 'package:cat_list/app/features/home/interactor/bloc/home_bloc.dart';

abstract class HomeRepository {
  Future<HomeState> fetchData(int catRequestEntity);

  Future<HomeState> getCatInfoByPicture();
}
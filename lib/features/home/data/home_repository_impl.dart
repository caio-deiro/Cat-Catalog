import 'package:cat_list/features/home/data/adapters/cat_adapter.dart';
import 'package:cat_list/features/home/interactor/bloc/home_bloc.dart';
import 'package:cat_list/features/home/interactor/repository/home_repository.dart';
import 'package:cat_list/shared/services/dio_service.dart';
import 'package:dio/dio.dart';

class HomeRepositoryImpl implements HomeRepository {
  final DioService dio;
  HomeRepositoryImpl(this.dio);
  @override
  Future<HomeState> fetchData() async {
    try {
      final response = await dio.get(
        DioService.baseUrl,
        queryParameters: {
          'limit': 100,
          'has_breeds': 1,
        },
      );

      final catList =
          // ignore: unnecessary_lambdas
          (response.data as List).map((e) => CatAdapter.fromJson(e)).toList();

      return HomeStateLoaded(catList);
    } on DioException catch (e, stk) {
      return HomeStateError(message: 'Ocorreu o erro: ${e.message}', stk: stk);
    }
  }
}

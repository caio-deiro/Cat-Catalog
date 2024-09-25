import 'package:cat_list/app/features/home/data/models/cat_model.dart';
import 'package:cat_list/app/features/home/interactor/errors/home_error.dart';
import 'package:result_dart/result_dart.dart';

abstract class HomeRepository {
  AsyncResult<List<CatModel>, HomeErrorsApi> fetchData(int catRequestEntity);

  AsyncResult<CatModel, HomeErrorsGemini> getCatInfoByPicture({required String imagePath});
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cat_list/app/shared/constants/api_key.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

class DioService extends DioForNative {
  static const baseUrl = 'https://api.thecatapi.com/v1/images/search';

  DioService() : super(BaseOptions(baseUrl: baseUrl)) {
    super.interceptors.add(DioServiceInterceptor());
  }
}

class DioServiceInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['x-api-key'] = Constants.apiKey;

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('Error: ${err.message} \n ErrorType: ${err.type} \n StackTrace: ${err.stackTrace}');
    super.onError(err, handler);
  }
}

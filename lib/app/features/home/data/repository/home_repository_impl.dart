import 'dart:convert';
import 'dart:io';

import 'package:cat_list/app/features/home/data/models/cat_model.dart';
import 'package:cat_list/app/features/home/interactor/errors/home_error.dart';
import 'package:cat_list/app/features/home/interactor/repository/home_repository.dart';
import 'package:cat_list/app/shared/services/dio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:result_dart/result_dart.dart';

class HomeRepositoryImpl implements HomeRepository {
  final DioService dio;
  final Gemini gemini;
  HomeRepositoryImpl({
    required this.dio,
    required this.gemini,
  });

  @override
  AsyncResult<List<CatModel>, HomeErrorsApi> fetchData(int page) async {
    try {
      final response = await dio.get(
        DioService.baseUrl,
        queryParameters: {
          'limit': 100,
          'has_breeds': 1,
          'page': page,
          'order': 'ASC',
        },
      );

      final List<dynamic> data = response.data;

      final catList = data.map((e) => CatModel.fromJson(e)).toList();

      return Result.success(catList);
    } on DioException catch (e, _) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          return Result.failure(
            HomeErrorsApi(
              'An error occurred while processing your request. Please try again.',
            ),
          );
        case DioExceptionType.connectionError:
          return Result.failure(
            HomeErrorsApi(
              'Your internet connection is not working. Please check your connection and try again.',
            ),
          );
        case DioExceptionType.badCertificate:
          return Result.failure(
            HomeErrorsApi(
              'An internal error occurred. Please try again later.',
            ),
          );
        // ignore: no_default_cases
        default:
          return Result.failure(
            HomeErrorsApi(
              'An unknown error occurred. Please try again later.',
            ),
          );
      }
    }
  }

  @override
  AsyncResult<CatModel, HomeErrorsGemini> getCatInfoByPicture({required String imagePath}) async {
    try {
      final file = File(imagePath);
      final result = await gemini.textAndImage(
        modelName: 'models/gemini-1.5-flash',
        text: '''
              Leia essa imagem, e se contiver um gato, retorne mais informações sobre para cada chave  do json abaixo.
              Substitua os valores de exemplo por valores reais. Os exemplos de numero devem ser retornados de 0 a 5.
              o id deve ser randomico, e o url deve ser o endereço de imagem correspondente a raça do gato encontrado.
              antes de enviar, valide se a imagem ainda está disponivel para visualização ou  se está fora do ar (erro 404).
              A url deve começar com http:// ou https://, lembre-se de retornar apenas  URL da imagem apenas, e nao da pagina toda. 
              Envie apenas o json como resposta, sem nenhum caracter especial antes ou depois dele.
              As infos devem ser todas em inglês.
              
              
              
                  {
                  id: 'idExample',
                  url: 'urlExample',
                  'breeds': [
                  {
                  'name': 'catNameExamble',
                  description: 'descriptionExample',
                  origin: 'originExample',
                  life_span: 'lifeSpanExample',
                  temperament: 'temperamentExample',
                  adaptability: exampleNumber,
                  affection_level: exampleNumber,
                  child_friendly: exampleNumber,
                  dog_friendly: exampleNumber,
                  energy_level: exampleNumber,  
                  intelligence: exampleNumber,
                  stranger_friendly: exampleNumber,
                  }
                  ],
                  
                  }    
              
      
              ''',
        images: [
          file.readAsBytesSync(),
        ],
      );

      if (result?.content?.parts?.last.text != null && result?.content?.parts?.last.text?.toLowerCase() != 'null') {
        debugPrint(result!.content!.parts!.last.text);

        final decodedResponse = json.decode(result.content!.parts!.last.text!);

        if (decodedResponse is! Map<String, dynamic>) {
          return Result.failure(HomeErrorsGemini("I can't recognize this cat, try again please!"));
        }

        final cat = CatModel.fromJson(decodedResponse);
        return Result.success(cat);
      } else {
        return Result.failure(HomeErrorsGemini("I can't see a cat in this picture"));
      }
    } on GeminiException catch (e, stk) {
      debugPrintStack(label: e.message.toString(), stackTrace: stk);
      return Result.failure(HomeErrorsGemini('An error occurred while processing your request. Please try again.'));
    }
  }
}

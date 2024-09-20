import 'dart:convert';
import 'dart:io';

import 'package:cat_list/features/home/data/models/cat_model.dart';
import 'package:cat_list/features/home/interactor/bloc/home_bloc.dart';
import 'package:cat_list/features/home/interactor/repository/home_repository.dart';
import 'package:cat_list/shared/services/dio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class HomeRepositoryImpl implements HomeRepository {
  final DioService dio;
  final HomeState homeState;
  final ImagePicker picker;

  HomeRepositoryImpl({
    required this.dio,
    required this.homeState,
    required this.picker,
  });

  @override
  Future<HomeState> fetchData(int page) async {
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

      // ignore: unnecessary_lambdas
      final catList = data.map((e) => CatModel.fromJson(e)).toList();

      return homeState.copyWith(
        previousList: catList,
        status: HomeStateStatus.loaded,
      );
    } on DioException catch (e, _) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          return homeState.copyWith(
            errorMessage: 'An error occurred while processing your request. Please try again later.',
            status: HomeStateStatus.error,
          );
        case DioExceptionType.connectionError:
          return homeState.copyWith(
            errorMessage: 'Your internet connection is not working. Please check your connection and try again.',
            status: HomeStateStatus.error,
          );
        case DioExceptionType.badCertificate:
          return homeState.copyWith(
            errorMessage: 'An internal error occurred. Please try again later.',
            status: HomeStateStatus.error,
          );
        // ignore: no_default_cases
        default:
          return homeState.copyWith(
            errorMessage: 'An unknown error occurred. Please try again later.',
            status: HomeStateStatus.error,
          );
      }
    }
  }

  @override
  Future<HomeState> getCatInfoByPicture() async {
    try {
      late final File? file;
      final gemini = Gemini.instance;
      final photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        file = File(photo.path);
        final result = await gemini.textAndImage(
          modelName: 'models/gemini-1.5-flash',
          text: '''
              Leia essa imagem, e se contiver um gato, retorne mais informações sobre para cada chave  do json abaixo.
              Substitua os valores de exemplo por valores reais. Os exemplos de numero devem ser retornados de 0 a 5.
              o id deve ser randomico, e o url deve ser o endereço de imagem dessa foto do gato, busque no freepik.com 
              A url deve começar com http:// ou https://, lembre-se de retornar apenas  URL da imagem apenas, e nao da pagina toda. 
              Envie apenas o json como resposta, sem nenhum caracter especial antes ou depois dele.
              Caso não identifique um gato, retorne null como resposta.
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
          final decodedResponse = json.decode(result!.content!.parts!.last.text!);

          final cat = CatModel.fromJson(decodedResponse as Map<String, dynamic>);
          return homeState.copyWith(
            catEntitieFromGemini: cat,
            status: HomeStateStatus.geminiLoaded,
          );
        } else {
          return homeState.copyWith(
            errorMessage: "I can't see a cat in this picture",
            status: HomeStateStatus.errorGemini,
          );
        }
      } else {
        return homeState.copyWith(status: HomeStateStatus.loaded);
      }
    } on GeminiException catch (e, stk) {
      debugPrintStack(label: e.message.toString(), stackTrace: stk);
      return homeState.copyWith(
        errorMessage: 'An error occurred while processing your request. Please try again.',
        status: HomeStateStatus.errorGemini,
      );
    }
  }
}

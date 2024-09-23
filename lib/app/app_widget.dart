import 'package:cat_list/app/features/home/data/repository/home_repository_impl.dart';
import 'package:cat_list/app/features/home/interactor/bloc/home_bloc.dart';
import 'package:cat_list/app/features/home/ui/pages/home_page.dart';
import 'package:cat_list/app/features/home/ui/pages/tabbar_page.dart';
import 'package:cat_list/app/shared/services/dio_service.dart';
import 'package:cat_list/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AppWidget extends StatelessWidget {
  final Environment environmentType;
  const AppWidget({super.key, required this.environmentType});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme().copyWith(
          bodyMedium: GoogleFonts.oswald(),
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (_) => BlocProvider<HomeBloc>(
              create: (context) => HomeBloc(
                repository: HomeRepositoryImpl(
                  picker: ImagePicker(),
                  dio: DioService(),
                  homeState: HomeState.initial(),
                ),
              )..add(HomeEventFetchData()),
              child: const HomePage(),
            ),
        '/catpage': (context) => const TabbarPage(),
      },
    );
  }
}

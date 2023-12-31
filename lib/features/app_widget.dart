import 'package:cat_list/env.dart';
import 'package:cat_list/features/details/ui/tabbar_page.dart';
import 'package:cat_list/features/home/data/home_repository_impl.dart';
import 'package:cat_list/features/home/interactor/bloc/home_bloc.dart';
import 'package:cat_list/features/home/ui/home_page.dart';
import 'package:cat_list/shared/services/dio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
                HomeRepositoryImpl(
                  DioService(),
                ),
              )..add(HomeEventFetchData()),
              child: const HomePage(),
            ),
        '/catpage': (context) => const TabbarPage()
      },
    );
  }
}

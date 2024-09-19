import 'dart:async';

import 'package:cat_list/features/home/interactor/bloc/home_bloc.dart';
import 'package:cat_list/features/home/ui/widgets/state_error_widget.dart';
import 'package:cat_list/features/home/ui/widgets/state_loaded_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _subscription = context.read<HomeBloc>().stream.listen((state) {
        if (state.status == HomeStateStatus.errorGemini) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                // backgroundColor: Colors.redAccent,
                duration: const Duration(seconds: 2),
                content: Text(state.errorMessage ?? ''),
              ),
            );
          }
        }

        if (state.status == HomeStateStatus.geminiLoaded) {
          if (mounted) {
            Navigator.of(context).pushNamed(
              '/catpage',
              arguments: state.catEntitieFromGemini,
            );
          }
        }
      });
      _scrollController.addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          context.read<HomeBloc>().add(HomeEventFetchData());
        }
      });
    });
  }

  @override
  void dispose() {
    context.read<HomeBloc>().close();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.status != HomeStateStatus.error) {
            return HomeStateLoadedWidget(
              scrollController: _scrollController,
            );
          }

          if (state.status == HomeStateStatus.error) {
            return HomeStateErrorWidget(state: state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

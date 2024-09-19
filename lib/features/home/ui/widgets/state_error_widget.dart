import 'package:cat_list/features/home/interactor/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeStateErrorWidget extends StatelessWidget {
  final HomeState state;
  const HomeStateErrorWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Column(
            children: [
              const Icon(Icons.sentiment_dissatisfied, size: 100),
              Text(state.errorMessage!),
            ],
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () => context.read<HomeBloc>().add(HomeEventFetchData()),
          child: const Text('Try again!'),
        ),
      ],
    );
  }
}

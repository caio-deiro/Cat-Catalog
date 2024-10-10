import 'package:cat_list/app/features/home/interactor/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeStateErrorWidget extends StatelessWidget {
  final HomeState state;
  final void Function() onTryAgain;
  const HomeStateErrorWidget({super.key, required this.state, required this.onTryAgain});

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
        if (state.status == HomeStateStatus.error)
          ElevatedButton(
            onPressed: () {
              context.read<HomeBloc>().add(HomeEventFetchData());
              onTryAgain();
            },
            child: const Text('Try again!'),
          ),
      ],
    );
  }
}

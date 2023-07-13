import 'package:cat_list/features/home/interactor/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeStateErrorWidget extends StatelessWidget {
  final HomeStateError state;
  const HomeStateErrorWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(state.message),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () => context.read<HomeBloc>().add(HomeEventFetchData()),
          child: const Text('Tentar Novamente!'),
        ),
      ],
    );
  }
}

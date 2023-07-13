// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cat_list/features/home/interactor/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class HomeStateLoadedWidget extends StatelessWidget {
  final HomeStateLoaded state;
  HomeStateLoadedWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  FocusNode keyboardFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              focusNode: keyboardFocus,
              onChanged: (value) {
                Timer(const Duration(milliseconds: 100), () {
                  context.read<HomeBloc>().add(HomeEventFilterCats(value));
                  Future.delayed(const Duration(seconds: 5))
                      .then((value) => keyboardFocus.unfocus());
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Search the cat'),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
            ),
            itemCount: state.list.length,
            shrinkWrap: true,
            padding: const EdgeInsets.all(5),
            itemBuilder: (context, index) {
              final cat = state.list[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/catpage',
                    arguments: cat,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Hero(
                    tag: 'cat${cat.id}',
                    child: Image.network(
                      cat.url,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

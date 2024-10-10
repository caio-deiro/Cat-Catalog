import 'dart:async';

import 'package:cat_list/app/features/home/interactor/bloc/home_bloc.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  final HomeBloc homeBloc;
  final FocusNode keyboardFocus;
  final TextEditingController searchBarTextEditingController;
  const AppBarWidget({
    required this.homeBloc,
    required this.keyboardFocus,
    required this.searchBarTextEditingController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 150,
      centerTitle: true,
      backgroundColor: Colors.pink[400],
      shadowColor: Colors.transparent,
      title: const Text(
        'Cat Catalog!',
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: TextField(
                  controller: searchBarTextEditingController,
                  focusNode: keyboardFocus,
                  onChanged: (value) {
                    Timer(const Duration(milliseconds: 100), () {
                      homeBloc.add(
                        HomeEventFilterCats(value),
                      );
                    });
                  },
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    label: Text(
                      'Search the cat',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () async {
                    homeBloc.add(
                      HomeEventGetCatFromGemini(),
                    );
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Take a picture'),
                      Icon(Icons.camera_alt),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

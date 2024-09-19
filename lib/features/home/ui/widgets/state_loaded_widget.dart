// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_list/features/home/interactor/bloc/home_bloc.dart';
import 'package:cat_list/shared/services/cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class HomeStateLoadedWidget extends StatelessWidget {
  final ScrollController scrollController;
  HomeStateLoadedWidget({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  FocusNode keyboardFocus = FocusNode();
  final cacheService = CacheService();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                expandedHeight: 150,
                centerTitle: true,
                backgroundColor: Colors.pink[400],
                shadowColor: Colors.transparent,
                forceElevated: innerBoxIsScrolled,
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
                            focusNode: keyboardFocus,
                            onChanged: (value) {
                              Timer(const Duration(milliseconds: 100), () {
                                context.read<HomeBloc>().add(
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
                              context.read<HomeBloc>().add(
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
              ),
            ];
          },
          body: Container(
            color: Colors.pink[400],
            child: GridView.builder(
              key: const Key('gridview-home-key'),
              controller: scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
              ),
              itemCount: context.read<HomeBloc>().state.list.length,
              padding: const EdgeInsets.all(5),
              itemBuilder: (context, index) {
                final cat = context.read<HomeBloc>().state.list[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/catpage',
                      arguments: cat,
                    );
                  },
                  child: Container(
                    key: Key('cat${cat.id}'),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Hero(
                      tag: 'cat${cat.id}',
                      child: CachedNetworkImage(
                        imageUrl: cat.url,
                        cacheManager: cacheService.customCache,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            color: Colors.black,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.pets),
                            SizedBox(height: 5),
                            Text('Image not found'),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Visibility(
          visible: context.read<HomeBloc>().state.status == HomeStateStatus.moreImageLoading,
          child: const Align(
            alignment: Alignment.bottomCenter,
            child: CircularProgressIndicator(),
          ),
        ),
        Visibility(
          visible: context.read<HomeBloc>().state.status == HomeStateStatus.loading,
          child: Container(
            color: Colors.black.withOpacity(0.2),
            child: const Center(
              child: Align(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

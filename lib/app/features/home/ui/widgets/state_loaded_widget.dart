// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_list/app/features/home/interactor/bloc/home_bloc.dart';
import 'package:cat_list/app/features/home/ui/widgets/app_bar_widget.dart';
import 'package:cat_list/app/features/home/ui/widgets/state_error_widget.dart';
import 'package:cat_list/app/shared/services/cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class HomeStateLoadedWidget extends StatelessWidget {
  final ScrollController scrollController;

  HomeStateLoadedWidget({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  /// FocusNode to control the keyboard
  FocusNode keyboardFocus = FocusNode();

  /// CacheService to handle cache images
  final cacheService = CacheService();

  /// TextEditingController to control the search bar
  final searchBarTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            AppBarWidget(
              homeBloc: context.read<HomeBloc>(),
              keyboardFocus: keyboardFocus,
              searchBarTextEditingController: searchBarTextEditingController,
            ),
          ],
          body: Container(
            color: Colors.pink[400],
            child: Visibility(
              visible: !(context.read<HomeBloc>().state.status == HomeStateStatus.error ||
                  context.read<HomeBloc>().state.status == HomeStateStatus.filtersEmpty),
              replacement: HomeStateErrorWidget(
                state: context.read<HomeBloc>().state,
                onTryAgain: () => searchBarTextEditingController.clear,
              ),
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

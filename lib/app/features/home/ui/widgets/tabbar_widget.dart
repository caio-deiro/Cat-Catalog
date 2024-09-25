import 'package:cat_list/app/features/home/ui/pages/cat_page.dart';
import 'package:cat_list/app/features/home/ui/pages/details_page.dart';
import 'package:flutter/material.dart';

import '../../interactor/entitie/cat_entitie.dart';

class TabbarWidget extends StatelessWidget {
  const TabbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments! as CatEntitie;
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            elevation: 0,
            backgroundColor: Colors.pink[50],
            toolbarHeight: 30,
            bottom: const TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              tabs: [
                Tab(
                  text: 'Cat',
                ),
                Tab(
                  text: 'Details',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              CatPage(
                cat: args,
              ),
              DetailsPage(
                cat: args,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

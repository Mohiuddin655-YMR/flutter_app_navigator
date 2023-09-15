import 'package:flutter/material.dart';

import 'utils/app_navigator.dart';
import 'utils/navigation_router.dart';

class AppRouter extends RouteGenerator {
  const AppRouter._();

  static AppRouter get I => const AppRouter._();

  @override
  Map<String, RouteBuilder> attach() {
    return {
      "page_1": page1,
      "page_2": page2,
      "page_3": page3,
    };
  }

  @override
  Widget onDefault(BuildContext context, Object? data) => page2(context, data);

  Widget page1(BuildContext context, Object? data) {
    return Page1(
      page: data is Map ? data["data"] : 1,
    );
  }

  Widget page2(BuildContext context, Object? data) {
    return Page1(
      page: data is Map ? data["data"] : 2,
    );
  }

  Widget page3(BuildContext context, Object? data) {
    return Page1(
      page: data is Map ? data["data"] : 3,
    );
  }
}

class Page1 extends StatelessWidget {
  final int page;

  const Page1({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page $page'),
      ),
      backgroundColor: page.isEven ? Colors.blue : Colors.white,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            AppNavigator.load(
              context,
              "page_${page + 1}",
              animationTime: 500,
              animationType: AnimType.slideRight,
              animationReserveTime: 500,
              curve: Curves.bounceIn,
              arguments: {
                "data": page + 1,
              },
            );
          },
          child: Text('Go to page ${page + 1}'),
        ),
      ),
    );
  }
}

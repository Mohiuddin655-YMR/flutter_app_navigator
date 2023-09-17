import 'package:flutter/material.dart';
import 'package:flutter_app_navigator/go_route.dart';
import 'package:flutter_app_navigator/navigate.dart';
import 'package:flutter_app_navigator/route.dart';

void main() => runApp(const Application());

class Application extends StatelessWidget {
  const Application({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'App Navigator',
    //   initialRoute: "page_1",
    //   onGenerateRoute: AppRouter.I.generate,
    // );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'App Navigator',
      routerConfig: AppGoRouter.I.config,
      routerDelegate: AppGoRouter.I.config.routerDelegate,
      routeInformationParser: AppGoRouter.I.config.routeInformationParser,
      routeInformationProvider: AppGoRouter.I.config.routeInformationProvider,
    );
  }
}

class AppRouter extends RouteGenerator {
  const AppRouter._();

  static AppRouter get I => const AppRouter._();

  /// OPTIONAL
  @override
  RouteConfig get config {
    return const RouteConfig(
      animationTime: 300,
      animationType: AnimationType.slideRight,
    );
  }

  @override
  Map<String, RouteBuilder> routes() {
    return {
      "page_1": page1,
      "page_2": page2,
    };
  }

  @override
  Widget onDefault(BuildContext context, Object? data) => page2(context, data);

  Widget page1(BuildContext context, Object? data) {
    return const Page1();
  }

  Widget page2(BuildContext context, Object? data) {
    return Page2(
      data: data.get("data"),
    );
  }
}

class AppGoRouter extends GoRouteGenerator {
  const AppGoRouter._({
    super.initialData,
    super.initialPath,
  });

  static AppGoRouter get I {
    return const AppGoRouter._(
      initialData: null,
      initialPath: "/",
    );
  }

  @override
  List<GoRouteConfig> routes() {
    return [
      GoRouteConfig(
        path: "/page_2",
        builder: (context, state) {
          return const Page2(
            data: "Hi",
          );
        },
      ),
    ];
  }

  @override
  Widget onDefault(BuildContext context, Object? state) {
    return const Page1();
  }
}

class Page1 extends StatefulWidget {
  const Page1({
    super.key,
  });

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  Object? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Data : $result",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                result = await AppNavigator.of(context).go(
                  "/page_2",
                  // arguments: {
                  //   "data": "Hi, I'm from Home...!",
                  // },
                  //animationType: AnimationType.zoom,
                );
                setState(() {});
              },
              child: const Text('Go to Second Page'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  final Object? data;

  const Page2({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$data",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                AppNavigator.of(context).goBack("Hey, I'm back...!");
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

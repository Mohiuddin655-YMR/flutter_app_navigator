import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'error.dart';

typedef GoRouteItem = GoRoute Function(
  String path,
  bool selfMode,
  GoRouteBuilder builder,
);
typedef GoRouteBuilder = Widget Function(
  BuildContext context,
  GoRouterState state,
);
typedef GoRouteRedirection = FutureOr<String> Function(
  BuildContext context,
  GoRouterState state,
);

abstract class GoRouteGenerator {
  final String initialPath;
  final Object? initialData;
  final bool initialSelfMode;

  const GoRouteGenerator({
    this.initialPath = "/",
    this.initialData,
    this.initialSelfMode = false,
  });

  List<GoRouteConfig> routes();

  Widget onDefault(BuildContext context, GoRouterState state);

  Widget onError(BuildContext context, GoRouterState state) {
    return const ErrorScreen();
  }

  List<String> get ignoreRedirections {
    return [
      'auth/:name',
    ];
  }

  bool isRedirection(String? path) {
    return !ignoreRedirections.contains(path);
  }

  Future<String?> redirection(BuildContext context, GoRouterState state) async {
    if (kIsWeb && isRedirection(state.fullPath)) {
      final bool loggedIn = await Future.value(true);
      if (!loggedIn) {
        return 'auth/sign_in';
      }
    }
    return null;
  }

  GoRoute build(GoRouteConfig config) {
    if (config.selfMode) {
      return GoRoute(
        name: config.path.replaceAll("/", ""),
        path: '${config.path}:name',
        builder: config.builder,
      );
    } else {
      return GoRoute(
        path: config.path,
        builder: config.builder,
      );
    }
  }

  GoRouter get config {
    var mRoutes = routes();
    mRoutes.insert(
      0,
      GoRouteConfig(
        path: initialPath,
        selfMode: initialSelfMode,
        builder: onDefault,
      ),
    );
    return GoRouter(
      // navigatorBuilder: (context, state, router, builder) {
      //   return Navigator(
      //     key: state.navigatorKey,
      //     pages: builder(context, state, router),
      //     onPopPage: (route, result) {
      //       return route.didPop(result);
      //     },
      //   );
      // },
      // builder: (BuildContext context, GoRouterState state, GoRouter router) {
      //   return MaterialApp.router(
      //     routerDelegate: state.routerDelegate,
      //     routeInformationParser: state.routeInformationParser,
      //   );
      // },
      observers: [NavigatorObserver()],
      initialLocation: initialPath,
      initialExtra: initialData,
      errorBuilder: onError,
      redirect: redirection,
      routes: mRoutes.map((e) => build(e)).toList(),
      navigatorKey: GlobalKey<NavigatorState>(),
    );
  }
}

class GoRouteConfig {
  final bool selfMode;
  final String path;
  final GlobalKey<NavigatorState>? parentNavigatorKey;
  final GoRouteBuilder? builder;
  final GoRouteBuilder? pageBuilder;
  final GoRouteRedirection? redirect;
  final List<RouteBase> innerRoutes;

  const GoRouteConfig({
    required this.path,
    this.selfMode = false,
    this.builder,
    this.pageBuilder,
    this.parentNavigatorKey,
    this.redirect,
    this.innerRoutes = const <RouteBase>[],
  });
}

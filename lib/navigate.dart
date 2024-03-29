library app_navigator;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_navigator/error.dart';
import 'package:go_router/go_router.dart';

import 'route.dart';

part 'route_info.dart';

extension AppNavigatorExtension on GoRouterState {
  String getPath(String name) => pathParameters[name] ?? "";

  String getQuery(String name) => uri.queryParameters[name] ?? "";
}

class AppNavigator {
  final BuildContext context;

  const AppNavigator._(this.context);

  factory AppNavigator.of(BuildContext context) => AppNavigator._(context);

  Future<T?> go<T extends Object>(
    String route, {
    Object? extra,
    String path = "",
    Map<String, dynamic> queryParams = const <String, dynamic>{},
  }) async {
    if (kIsWeb) {
      if (path.isNotEmpty || queryParams.isNotEmpty) {
        context.goNamed(
          route,
          extra: extra,
          pathParameters: {"name": path},
          queryParameters: queryParams,
        );
      } else {
        context.go(route, extra: extra);
      }
      return null;
    } else {
      if (path.isNotEmpty || queryParams.isNotEmpty) {
        return context.pushNamed(
          route,
          extra: extra,
          pathParameters: {"name": path},
          queryParameters: queryParams,
        );
      } else {
        return context.push(route, extra: extra);
      }
    }
  }

  void goHome(
    String route, {
    String path = "",
    Object? extra,
    Map<String, dynamic> queryParams = const <String, dynamic>{},
  }) {
    if (path.isNotEmpty || queryParams.isNotEmpty) {
      Router.neglect(context, () {
        context.goNamed(
          route,
          extra: extra,
          pathParameters: {"name": path},
          queryParameters: queryParams,
        );
      });
    } else {
      Router.neglect(context, () {
        context.go(route, extra: extra);
      });
    }
  }

  void goBack([Object? result]) {
    context.pop(result);
  }

  Future<T?> push<T extends Object?, R extends Object?>(
    RouteInfo info, {
    String? childRoute,
    bool? allowSnapshotting,
    Curve? animationCurve,
    int? animationTime,
    int? animationReserveTime,
    AnimationType? animationType,
    Map<String, dynamic> arguments = const {},
    Color? barrierColor,
    bool? barrierDismissible,
    String? barrierLabel,
    bool? fullscreenDialog,
    String? name,
    Flag? flag,
    bool? maintainState,
    bool? opaque,
    RoutePredicate? predicate,
    R? result,
  }) {
    if (info is _NamedRoute) {
      final base = info.base;
      final child = info.child;
      Map<String, dynamic> arg = {
        "__app_route_config__": RouteConfig(
          allowSnapshotting: allowSnapshotting,
          animationCurve: animationCurve,
          animationTime: animationTime,
          animationReserveTime: animationReserveTime,
          animationType: animationType,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          barrierLabel: barrierLabel,
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
          opaque: opaque,

        ),
      };

      arg.putIfAbsent("screen", () => child);
      if (arguments.isNotEmpty) {
        arg.addAll(arguments);
      }

      if (flag == Flag.replacement) {
        return Navigator.pushReplacementNamed(
          context,
          base,
          result: result,
          arguments: arg,
        );
      } else if (flag == Flag.clear) {
        return Navigator.pushNamedAndRemoveUntil(
          context,
          base,
          predicate ?? (value) => false,
          arguments: arg,
        );
      } else {
        return Navigator.pushNamed(
          context,
          base,
          arguments: arg,
        );
      }
    } else if (info is _WidgetRoute) {
      AppRoute<T> mRoute = AppRoute<T>(
        name: name,
        allowSnapshotting: allowSnapshotting ?? true,
        animationTime: animationTime ?? 500,
        animationReserveTime: animationReserveTime,
        animationType: animationType ?? AnimationType.slideRight,
        arguments: arguments,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible ?? false,
        barrierLabel: barrierLabel,
        animationCurve: animationCurve ?? Curves.decelerate,
        fullscreenDialog: fullscreenDialog ?? false,
        maintainState: maintainState ?? true,
        opaque: opaque ?? true,
        builder: (_) {
          if (info.builder != null) {
            return info.builder!(_);
          } else if (info.child != null) {
            return info.child!;
          } else {
            return const ErrorScreen();
          }
        },
      );

      if (flag == Flag.replacement) {
        return Navigator.pushReplacement(
          context,
          result: result,
          mRoute,
        );
      } else if (flag == Flag.clear) {
        return Navigator.pushAndRemoveUntil(
          context,
          mRoute,
          predicate ?? (route) => false,
        );
      } else {
        return Navigator.pushNamed(context, "error");
      }
    } else {
      return Navigator.pushNamed(context, "error");
    }
  }

  void pop<T extends Object?>([T? result]) => Navigator.pop(context, result);

  static Future<T?> load<T extends Object?, R extends Object?>(
    BuildContext context,
    dynamic route, {
    bool? allowSnapshotting,
    Curve? animationCurve,
    int? animationTime,
    int? animationReserveTime,
    AnimationType? animationType,
    Map<String, dynamic> arguments = const {},
    Color? barrierColor,
    bool? barrierDismissible,
    String? barrierLabel,
    bool? fullscreenDialog,
    String? name,
    Flag? flag,
    bool? maintainState,
    bool? opaque,
    RoutePredicate? predicate,
    R? result,
  }) {
    return AppNavigator.of(context).push(
      route,
      allowSnapshotting: allowSnapshotting,
      animationCurve: animationCurve,
      animationTime: animationTime,
      animationReserveTime: animationReserveTime,
      animationType: animationType,
      arguments: arguments,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      fullscreenDialog: fullscreenDialog,
      name: name,
      flag: flag,
      maintainState: maintainState,
      opaque: opaque,
      predicate: predicate,
      result: result,
    );
  }

  static void terminate(BuildContext context, {Object? result}) {
    AppNavigator.of(context).pop(result);
  }
}

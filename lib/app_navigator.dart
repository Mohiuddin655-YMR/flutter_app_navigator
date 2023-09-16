library app_navigator;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'app_router.dart';

extension AppNavigatorExtension on GoRouterState {
  String getPath(String name) => pathParameters[name] ?? "";

  String getQuery(String name) => uri.queryParameters[name] ?? "";
}

class AppNavigator {
  final BuildContext context;

  const AppNavigator._(this.context);

  factory AppNavigator.of(BuildContext context) => AppNavigator._(context);

  void go(
    String route, {
    Object? extra,
    String path = "",
    Map<String, dynamic> queryParams = const <String, dynamic>{},
  }) {
    if (path.isNotEmpty || queryParams.isNotEmpty) {
      if (kIsWeb) {
        context.goNamed(
          route,
          extra: extra,
          pathParameters: {"name": path},
          queryParameters: queryParams,
        );
      } else {
        context.pushNamed(
          route,
          extra: extra,
          pathParameters: {"name": path},
          queryParameters: queryParams,
        );
      }
    } else {
      if (kIsWeb) {
        context.go(route, extra: extra);
      } else {
        context.push(route, extra: extra);
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
    if (route is String) {
      Map<String, dynamic> arg = {
        "__app_route_config__": AppRouteConfig(
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

      if (arguments.isNotEmpty) {
        arg.addAll(arguments);
      }

      if (flag == Flag.replacement) {
        return Navigator.pushReplacementNamed(
          context,
          route,
          result: result,
          arguments: arg,
        );
      } else if (flag == Flag.clear) {
        return Navigator.pushNamedAndRemoveUntil(
          context,
          route,
          predicate ?? (value) => false,
          arguments: arg,
        );
      } else {
        return Navigator.pushNamed(
          context,
          route,
          arguments: arg,
        );
      }
    } else if (route is Widget) {
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
        builder: (_) => route,
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

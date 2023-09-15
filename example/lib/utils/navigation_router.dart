import 'package:flutter/material.dart';

import 'app_navigator.dart';

typedef RouteBuilder = Widget Function(BuildContext context, Object? data);

extension _AppRouteExtenstion on Object? {
  T? call<T>(String key) {
    var root = this;
    if (root is Map<String, dynamic>) {
      var data = root[key];
      if (data is T) {
        return data;
      } else {
        return null;
      }
    } else {
      if (root is T) {
        return root;
      } else {
        return null;
      }
    }
  }
}

abstract class RouteGenerator {
  const RouteGenerator();

  Map<String, RouteBuilder> attach();

  Widget onDefault(BuildContext context, Object? data);

  Widget onError(BuildContext context, Object? data) => const ErrorScreen();

  Route<T> generate<T>(RouteSettings settings) {
    var name = settings.name;
    var data = settings.arguments;
    var mRoutes = attach();
    var isValidRoute = mRoutes.isNotEmpty;

    var routeConfig = data("__route_config__") as Object?;
    var allowSnapshotting = routeConfig("allowSnapshotting");
    var animationTime = routeConfig("animationTime");
    var animationReserveTime = routeConfig("animationReserveTime");
    var animationType = routeConfig("animationType");
    var barrierColor = routeConfig("barrierColor");
    var barrierDismissible = routeConfig("barrierDismissible");
    var barrierLabel = routeConfig("barrierLabel");
    var curve = routeConfig("curve");
    var fullscreenDialog = routeConfig("fullscreenDialog");
    var maintainState = routeConfig("maintainState");
    var opaque = routeConfig("opaque");

    if (isValidRoute) {
      var route = mRoutes[name];
      if (route != null) {
        return AppRoute<T>(
          name: name,
          allowSnapshotting: allowSnapshotting ?? true,
          animationTime: animationTime ?? 500,
          animationReserveTime: animationReserveTime,
          animationType: animationType ?? AnimType.slideRight,
          arguments: data,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible ?? false,
          barrierLabel: barrierLabel,
          curve: curve ?? Curves.decelerate,
          fullscreenDialog: fullscreenDialog ?? false,
          maintainState: maintainState ?? true,
          opaque: opaque ?? true,
          builder: (_) => route(_, data),
        );
      } else {
        return AppRoute<T>(
          name: name,
          allowSnapshotting: allowSnapshotting ?? true,
          animationTime: animationTime ?? 500,
          animationReserveTime: animationReserveTime,
          animationType: animationType ?? AnimType.slideRight,
          arguments: data,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible ?? false,
          barrierLabel: barrierLabel,
          curve: curve ?? Curves.decelerate,
          fullscreenDialog: fullscreenDialog ?? false,
          maintainState: maintainState ?? true,
          opaque: opaque ?? true,
          builder: (context) => onError(context, data),
        );
      }
    } else {
      return AppRoute<T>(
        name: name,
        allowSnapshotting: allowSnapshotting ?? true,
        animationTime: animationTime ?? 500,
        animationReserveTime: animationReserveTime,
        animationType: animationType ?? AnimType.slideRight,
        arguments: data,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible ?? false,
        barrierLabel: barrierLabel,
        curve: curve ?? Curves.decelerate,
        fullscreenDialog: fullscreenDialog ?? false,
        maintainState: maintainState ?? true,
        opaque: opaque ?? true,
        builder: (context) => onDefault(context, data),
      );
    }
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            "No screen found!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}

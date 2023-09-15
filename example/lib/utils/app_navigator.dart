library app_navigator;

import 'package:flutter/material.dart';

class AppNavigator {
  final BuildContext context;

  const AppNavigator._(this.context);

  factory AppNavigator.of(BuildContext context) => AppNavigator._(context);

  Future<T?> go<T extends Object?, R extends Object?>(
    dynamic route, {
    String? name,
    Map<String, dynamic>? arguments,
    Flag flag = Flag.none,
    RoutePredicate? predicate,
    R? result,
    AnimType type = AnimType.slideLeft,
  }) {
    if (flag == Flag.replacement) {
      if (route is String) {
        return Navigator.pushReplacementNamed(
          context,
          route,
          result: result,
          arguments: arguments,
        );
      } else if (route is Widget) {
        return Navigator.pushReplacement(
          context,
          result: result,
          AppRoute<T>(
            name: name,
            arguments: arguments,
            builder: (_) => route,
          ),
        );
      } else {
        return Navigator.pushNamed(context, "error");
      }
    } else if (flag == Flag.clear) {
      if (route is String) {
        return Navigator.pushNamedAndRemoveUntil(
          context,
          route,
          predicate ?? (value) => false,
          arguments: arguments,
        );
      } else if (route is Widget) {
        return Navigator.pushAndRemoveUntil(
            context,
            AppRoute<T>(
              name: name,
              arguments: arguments,
              builder: (_) => route,
            ),
            predicate ?? (route) => false);
      } else {
        return Navigator.pushNamed(context, "error");
      }
    } else {
      if (route is String) {
        return Navigator.pushNamed(
          context,
          route,
          arguments: arguments,
        );
      } else if (route is Widget) {
        return Navigator.push(
          context,
          AppRoute<T>(
            name: name,
            arguments: arguments,
            builder: (_) => route,
          ),
        );
      } else {
        return Navigator.pushNamed(context, "error");
      }
    }
  }

  void back([Object? result]) => Navigator.pop(context, result);

  static Future<T?> load<T extends Object?, R extends Object?>(
    BuildContext context,
    dynamic route, {
    bool allowSnapshotting = true,
    int animationTime = 500,
    int? animationReserveTime,
    AnimType animationType = AnimType.slideLeft,
    Map<String, dynamic> arguments = const {},
    Color? barrierColor,
    bool barrierDismissible = false,
    String? barrierLabel,
    Curve curve = Curves.decelerate,
    bool fullscreenDialog = false,
    String? name,
    Flag flag = Flag.none,
    bool maintainState = true,
    bool opaque = true,
    RoutePredicate? predicate,
    R? result,
  }) {
    if (route is String) {
      arguments.putIfAbsent("__route_config__", () {
        return {
          "allowSnapshotting": allowSnapshotting,
          "animationTime": animationTime,
          "animationReserveTime": animationReserveTime,
          "animationType": animationType,
          "barrierColor": barrierColor,
          "barrierDismissible": barrierDismissible,
          "barrierLabel": barrierLabel,
          "curve": curve,
          "fullscreenDialog": fullscreenDialog,
          "maintainState": maintainState,
          "opaque": opaque,
        };
      });

      if (flag == Flag.replacement) {
        return Navigator.pushReplacementNamed(
          context,
          route,
          result: result,
          arguments: arguments,
        );
      } else if (flag == Flag.clear) {
        return Navigator.pushNamedAndRemoveUntil(
          context,
          route,
          predicate ?? (value) => false,
          arguments: arguments,
        );
      } else {
        return Navigator.pushNamed(
          context,
          route,
          arguments: arguments,
        );
      }
    } else if (route is Widget) {
      AppRoute<T> mRoute = AppRoute<T>(
        name: name,
        allowSnapshotting: allowSnapshotting,
        animationTime: animationTime,
        animationReserveTime: animationReserveTime,
        animationType: animationType,
        arguments: arguments,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        curve: curve,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
        opaque: opaque,
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

  static void terminate(BuildContext context, [Object? result]) {
    AppNavigator.of(context).back(result);
  }
}

typedef AppRouteBuilder<T> = Widget Function(BuildContext context);

class AppRoute<T> extends PageRouteBuilder<T> {
  final String? name;
  final int animationTime;
  final int? animationReserveTime;
  final AnimType animationType;
  final Object? arguments;
  final Curve curve;
  final AppRouteBuilder<T> builder;

  AppRoute({
    super.allowSnapshotting,
    super.barrierColor,
    super.barrierDismissible,
    super.barrierLabel,
    super.fullscreenDialog,
    super.maintainState,
    super.opaque,
    this.name,
    this.animationTime = 300,
    this.animationReserveTime,
    this.arguments,
    this.animationType = AnimType.slideRight,
    this.curve = Curves.decelerate,
    required this.builder,
  }) : super(
          transitionDuration: Duration(milliseconds: animationTime),
          reverseTransitionDuration: Duration(
            milliseconds: animationReserveTime ?? animationTime,
          ),
          pageBuilder: (_, __, ___) => builder.call(_),
          settings: RouteSettings(
            name: name,
            arguments: arguments,
          ),
        );

  @override
  RouteSettings get settings {
    return RouteSettings(
      name: name ?? super.settings.name,
      arguments: arguments ?? super.settings.arguments,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Anim(
      CurvedAnimation(parent: animation, curve: curve),
      secondaryAnimation,
    ).select(child, animationType);
  }
}

class Anim {
  final Animation<double> primary;
  final Animation<double> secondary;

  const Anim(
    this.primary, [
    Animation<double>? secondary,
  ]) : secondary = secondary ?? primary;

  Widget select(Widget view, AnimType type) {
    switch (type) {
      case AnimType.none:
        return _slideLeft(view);
      case AnimType.card:
        return _slideLeft(view);
      case AnimType.diagonal:
        return _slideLeft(view);
      case AnimType.fadeIn:
        return _fadeIn(view);
      case AnimType.inAndOut:
        return _slideLeft(view);
      case AnimType.rotation:
        return _rotation(view);
      case AnimType.shrink:
        return _slideLeft(view);
      case AnimType.split:
        return _slideLeft(view);
      case AnimType.slideLeft:
        return _slideLeft(view);
      case AnimType.slideRight:
        return _slideRight(view);
      case AnimType.slideDown:
        return _slideDown(view);
      case AnimType.slideUp:
        return _slideUp(view);
      case AnimType.slideLeftWithFade:
        return _slideLeftWithFade(view);
      case AnimType.slideRightWithFade:
        return _slideRightWithFade(view);
      case AnimType.slideDownWithFade:
        return _slideDownWithFade(view);
      case AnimType.slideUpWithFade:
        return _slideUpWithFade(view);
      case AnimType.swipeLeft:
        return _slideRight(view);
      case AnimType.swipeRight:
        return _slideRight(view);
      case AnimType.windmill:
        return _slideRight(view);
      case AnimType.zoom:
        return _zoom(view);
      case AnimType.zoomWithFade:
        return _zoomWithFade(view);
    }
  }

  Widget _fadeIn(Widget view) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(primary),
      child: view,
    );
  }

  Widget _slideUp(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(primary),
      child: view,
    );
  }

  Widget _slideDown(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, -1.0),
        end: Offset.zero,
      ).animate(primary),
      child: view,
    );
  }

  Widget _slideLeft(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(primary),
      child: view,
    );
  }

  Widget _slideRight(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(primary),
      child: view,
    );
  }

  Widget _slideUpWithFade(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(primary),
      child: Opacity(opacity: primary.value, child: view),
    );
  }

  Widget _slideDownWithFade(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, -1.0),
        end: Offset.zero,
      ).animate(primary),
      child: Opacity(opacity: primary.value, child: view),
    );
  }

  Widget _slideLeftWithFade(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(primary),
      child: Opacity(opacity: primary.value, child: view),
    );
  }

  Widget _slideRightWithFade(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(primary),
      child: Opacity(opacity: primary.value, child: view),
    );
  }

  Widget _rotation(Widget view) {
    return RotationTransition(
      turns: Tween<double>(
        begin: 0.5,
        end: 1.0,
      ).animate(primary),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(primary),
        child: view,
      ),
    );
  }

  Widget _zoom(Widget view) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(primary),
      child: view,
    );
  }

  Widget _zoomWithFade(Widget view) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(primary),
      child: Opacity(opacity: primary.value, child: view),
    );
  }
}

enum Flag {
  none,
  clear,
  replacement,
}

enum AnimType {
  none,
  card,
  diagonal,
  fadeIn,
  inAndOut,
  shrink,
  rotation,
  split,
  slideLeft,
  slideRight,
  slideDown,
  slideUp,
  slideLeftWithFade,
  slideRightWithFade,
  slideDownWithFade,
  slideUpWithFade,
  swipeLeft,
  swipeRight,
  windmill,
  zoom,
  zoomWithFade;
}

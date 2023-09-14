library app_navigator;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

part 'app_navigator_extension.dart';

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
            child: route,
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
              child: route,
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
            child: route,
          ),
        );
      } else {
        return Navigator.pushNamed(context, "error");
      }
    }
  }

  void pop([Object? result]) => Navigator.pop(context, result);

  static Future<T?> load<T extends Object?, R extends Object?>(
    BuildContext context,
    dynamic route, {
    String? name,
    Map<String, dynamic>? arguments,
    Flag flag = Flag.none,
    RoutePredicate? predicate,
    R? result,
    AnimType type = AnimType.slideLeft,
  }) {
    return AppNavigator.of(context).push(
      route,
      name: name,
      arguments: arguments,
      flag: flag,
      predicate: predicate,
      result: result,
      type: type,
    );
  }

  static void terminate(BuildContext context, [Object? result]) {
    AppNavigator.of(context).pop(result);
  }
}

class AppRoute<T> extends PageRouteBuilder<T> {
  final String? name;
  final int animationTime;
  final int? animationReserveTime;
  final AnimType animationType;
  final Map<String, dynamic>? arguments;
  final Curve curve;
  final Widget child;

  AppRoute({
    super.allowSnapshotting,
    super.barrierColor,
    super.barrierDismissible,
    super.barrierLabel,
    super.fullscreenDialog,
    super.maintainState,
    super.opaque,
    super.settings,
    super.transitionsBuilder,
    super.transitionDuration,
    super.reverseTransitionDuration,
    this.name,
    this.animationTime = 300,
    this.animationReserveTime,
    this.arguments,
    this.animationType = AnimType.slideRight,
    this.curve = Curves.decelerate,
    required this.child,
  }) : super(pageBuilder: (context, a1, a2) => child);

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

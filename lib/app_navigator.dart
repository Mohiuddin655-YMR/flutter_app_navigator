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
  final int? animationTime;
  final AnimType animationType;
  final Map<String, dynamic>? arguments;
  final Widget child;

  AppRoute({
    this.name,
    this.animationTime,
    this.arguments,
    this.animationType = AnimType.slideRight,
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
  Duration get transitionDuration => animationTime != null
      ? Duration(milliseconds: animationTime ?? 300)
      : super.transitionDuration;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Anim(animation, secondaryAnimation).select(child, animationType);
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
        return slideLeft(view);
      case AnimType.card:
        return slideLeft(view);
      case AnimType.diagonal:
        return slideLeft(view);
      case AnimType.fade:
        return fade(view);
      case AnimType.inAndOut:
        return slideLeft(view);
      case AnimType.shrink:
        return slideLeft(view);
      case AnimType.spin:
        return slideLeft(view);
      case AnimType.split:
        return slideLeft(view);
      case AnimType.slideLeft:
        return slideLeft(view);
      case AnimType.slideRight:
        return slideRight(view);
      case AnimType.slideDown:
        return slideRight(view);
      case AnimType.slideUp:
        return slideRight(view);
      case AnimType.swipeLeft:
        return slideRight(view);
      case AnimType.swipeRight:
        return slideRight(view);
      case AnimType.windmill:
        return slideRight(view);
      case AnimType.zoom:
        return slideRight(view);
    }
  }

  Widget slideLeft(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(primary),
      child: view,
    );
  }

  Widget slideRight(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(primary),
      child: view,
    );
  }

  Widget slideRightWithFade(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(primary),
      child: Opacity(
        opacity: primary.value,
        child: view,
      ),
    );
  }

  Widget fade(Widget view) {
    return Opacity(
      opacity: primary.value,
      child: view,
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
  fade,
  inAndOut,
  shrink,
  spin,
  split,
  slideLeft,
  slideRight,
  slideDown,
  slideUp,
  swipeLeft,
  swipeRight,
  windmill,
  zoom;
}

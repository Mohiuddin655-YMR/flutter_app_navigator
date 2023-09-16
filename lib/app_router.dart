part of 'app_navigator.dart';

typedef RouteBuilder = Widget Function(BuildContext context, Object? data);

extension AppRouteExtenstion on Object? {
  T call<T>(String key, T secondary) {
    var root = this;
    if (root is Map<String, dynamic>) {
      var data = root[key];
      if (data is T) {
        return data;
      } else {
        return secondary;
      }
    } else {
      if (root is T) {
        return root;
      } else {
        return secondary;
      }
    }
  }

  T? get<T>(String key, [T? secondary]) => call(key, secondary);
}

abstract class AppRouteGenerator {
  const AppRouteGenerator();

  AppRouteConfig get config => const AppRouteConfig();

  Map<String, RouteBuilder> routes();

  Widget onDefault(BuildContext context, Object? data);

  Widget onError(BuildContext context, Object? data) => const ErrorScreen();

  Route<T> generate<T>(RouteSettings settings) {
    var name = settings.name;
    var data = settings.arguments;
    var mRoutes = routes();
    var isValidRoute = mRoutes.isNotEmpty;

    var mConfig = config.adjust(data("__app_route_config__", config));
    var allowSnapshotting = mConfig.allowSnapshotting;
    var animationCurve = mConfig.animationCurve;
    var animationTime = mConfig.animationTime;
    var animationReserveTime = mConfig.animationReserveTime;
    var animationType = mConfig.animationType;
    var barrierColor = mConfig.barrierColor;
    var barrierDismissible = mConfig.barrierDismissible;
    var barrierLabel = mConfig.barrierLabel;
    var fullscreenDialog = mConfig.fullscreenDialog;
    var maintainState = mConfig.maintainState;
    var opaque = mConfig.opaque;

    if (isValidRoute) {
      var route = mRoutes[name];
      if (route != null) {
        return AppRoute<T>(
          name: name,
          allowSnapshotting: allowSnapshotting,
          animationTime: animationTime,
          animationReserveTime: animationReserveTime,
          animationType: animationType,
          arguments: data,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          barrierLabel: barrierLabel,
          animationCurve: animationCurve,
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
          opaque: opaque,
          builder: (_) => route(_, data),
        );
      } else {
        return AppRoute<T>(
          name: name,
          allowSnapshotting: allowSnapshotting,
          animationCurve: animationCurve,
          animationTime: animationTime,
          animationReserveTime: animationReserveTime,
          animationType: animationType,
          arguments: data,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          barrierLabel: barrierLabel,
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
          opaque: opaque,
          builder: (context) => onError(context, data),
        );
      }
    } else {
      return AppRoute<T>(
        name: name,
        allowSnapshotting: allowSnapshotting,
        animationTime: animationTime,
        animationReserveTime: animationReserveTime,
        animationType: animationType,
        arguments: data,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        animationCurve: animationCurve,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
        opaque: opaque,
        builder: (context) => onDefault(context, data),
      );
    }
  }
}

class AppRouteConfig {
  final bool? allowSnapshotting;
  final Curve? animationCurve;
  final int? animationTime;
  final int? animationReserveTime;
  final AnimationType? animationType;
  final Color? barrierColor;
  final bool? barrierDismissible;
  final String? barrierLabel;
  final bool? fullscreenDialog;
  final bool? maintainState;
  final bool? opaque;

  const AppRouteConfig({
    this.allowSnapshotting,
    this.animationCurve,
    this.animationTime,
    this.animationReserveTime,
    this.animationType,
    this.barrierColor,
    this.barrierDismissible,
    this.barrierLabel,
    this.fullscreenDialog,
    this.maintainState,
    this.opaque,
  });

  AppRouteConfig adjust(AppRouteConfig config) {
    return AppRouteConfig(
      allowSnapshotting: config.allowSnapshotting ?? allowSnapshotting,
      animationCurve: config.animationCurve ?? animationCurve,
      animationTime: config.animationTime ?? animationTime,
      animationReserveTime: config.animationReserveTime ?? animationReserveTime,
      animationType: config.animationType ?? animationType,
      barrierColor: config.barrierColor ?? barrierColor,
      barrierDismissible: config.barrierDismissible ?? barrierDismissible,
      barrierLabel: config.barrierLabel ?? barrierLabel,
      fullscreenDialog: config.fullscreenDialog ?? fullscreenDialog,
      maintainState: config.maintainState ?? maintainState,
      opaque: config.opaque ?? opaque,
    );
  }
}

class AppRoute<T> extends PageRouteBuilder<T> {
  final String? name;
  final int? animationTime;
  final int? animationReserveTime;
  final AnimationType? animationType;
  final Object? arguments;
  final Curve? animationCurve;
  final Widget Function(BuildContext context) builder;

  AppRoute({
    bool? allowSnapshotting,
    bool? barrierDismissible,
    bool? fullscreenDialog,
    bool? opaque,
    bool? maintainState,
    super.barrierColor,
    super.barrierLabel,
    this.name,
    this.animationTime,
    this.animationReserveTime,
    this.arguments,
    this.animationType,
    this.animationCurve,
    required this.builder,
  }) : super(
          allowSnapshotting: allowSnapshotting ?? true,
          barrierDismissible: barrierDismissible ?? false,
          fullscreenDialog: fullscreenDialog ?? false,
          opaque: opaque ?? true,
          maintainState: maintainState ?? true,
          transitionDuration: Duration(milliseconds: animationTime ?? 300),
          reverseTransitionDuration: Duration(
            milliseconds: animationReserveTime ?? animationTime ?? 300,
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
      CurvedAnimation(
        parent: animation,
        curve: animationCurve ?? Curves.decelerate,
      ),
      secondaryAnimation,
    ).select(child, animationType ?? AnimationType.slideRight);
  }
}

class Anim {
  final Animation<double> primary;
  final Animation<double> secondary;

  const Anim(
    this.primary, [
    Animation<double>? secondary,
  ]) : secondary = secondary ?? primary;

  Widget select(Widget view, AnimationType type) {
    switch (type) {
      case AnimationType.none:
        return _slideLeft(view);
      case AnimationType.card:
        return _slideLeft(view);
      case AnimationType.diagonal:
        return _slideLeft(view);
      case AnimationType.fadeIn:
        return _fadeIn(view);
      case AnimationType.inAndOut:
        return _slideLeft(view);
      case AnimationType.rotation:
        return _rotation(view);
      case AnimationType.shrink:
        return _slideLeft(view);
      case AnimationType.split:
        return _slideLeft(view);
      case AnimationType.slideLeft:
        return _slideLeft(view);
      case AnimationType.slideRight:
        return _slideRight(view);
      case AnimationType.slideDown:
        return _slideDown(view);
      case AnimationType.slideUp:
        return _slideUp(view);
      case AnimationType.slideLeftWithFade:
        return _slideLeftWithFade(view);
      case AnimationType.slideRightWithFade:
        return _slideRightWithFade(view);
      case AnimationType.slideDownWithFade:
        return _slideDownWithFade(view);
      case AnimationType.slideUpWithFade:
        return _slideUpWithFade(view);
      case AnimationType.swipeLeft:
        return _slideRight(view);
      case AnimationType.swipeRight:
        return _slideRight(view);
      case AnimationType.windmill:
        return _slideRight(view);
      case AnimationType.zoom:
        return _zoom(view);
      case AnimationType.zoomWithFade:
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

enum AnimationType {
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

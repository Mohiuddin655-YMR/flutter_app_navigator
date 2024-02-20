part of 'navigate.dart';

abstract class RouteInfo {
  const RouteInfo();

  factory RouteInfo.named(
    String base, {
    String? child,
  }) {
    return _NamedRoute(
      base: base,
      child: child,
    );
  }

  factory RouteInfo.widget(Widget base) {
    return _WidgetRoute(child: base);
  }

  factory RouteInfo.builder(Widget Function(BuildContext context) builder) {
    return _WidgetRoute(builder: builder);
  }
}

class _WidgetRoute extends RouteInfo {
  final Widget? child;
  final Widget Function(BuildContext context)? builder;

  _WidgetRoute({
    this.child,
    this.builder,
  });
}

class _NamedRoute extends RouteInfo {
  final String base;
  final String? child;

  const _NamedRoute({
    required this.base,
    this.child,
  });
}

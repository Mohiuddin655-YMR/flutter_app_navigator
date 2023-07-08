part of 'app_navigator.dart';

extension AppNavigatorExtension on GoRouterState {
  String getPath(String name) => pathParameters[name] ?? "";

  String getQuery(String name) => queryParameters[name] ?? "";
}

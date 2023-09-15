import 'package:flutter/material.dart';

import 'route.dart';

void main() => runApp(const Application());

class Application extends StatelessWidget {
  const Application({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom Page Transitions App',
      initialRoute: "page_1",
      onGenerateRoute: AppRouter.I.generate,
    );
  }
}
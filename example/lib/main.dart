import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_navigator/app_navigator.dart';

void main() => runApp(const Application());

class Application extends StatelessWidget {
  const Application({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom Page Transitions App',
      home: Page1(),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 1'),
      ),
      backgroundColor: Colors.blue,
      body: Center(
        child: MaterialButton(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          onPressed: () {
            Navigator.push(
              context,
              AppRoute(
                child: const Page2(),
                animationType: AnimType.zoomWithFade,
                animationTime: 400,
                animationReserveTime: 400,
              ),
            );
          },
          child: const Text('Go to page 2'),
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    if (kDebugMode) {
      print(args);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 2'),
      ),
      body: const Center(
        child: Text('Page 2'),
      ),
    );
  }
}

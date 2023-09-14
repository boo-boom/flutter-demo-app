import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                context.pushNamed('dropDownMenu');
              },
              child: const Text('自定义下拉菜单'),
            ),
            ElevatedButton(
              onPressed: () {
                context.pushNamed('multipleWebview');
              },
              child: const Text('多webview加载优化'),
            ),
          ],
        ),
      ),
    );
  }
}

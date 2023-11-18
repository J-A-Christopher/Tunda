import 'package:flutter/material.dart';
import 'package:tunda/presentation/widgets/tunda_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tunda'),
          centerTitle: true,
          elevation: 0,
        ),
        body: const TundaWidget());
  }
}

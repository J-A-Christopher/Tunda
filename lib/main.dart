import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunda/bloc_observer.dart';
import 'package:tunda/presentation/bloc/fruit_tester_bloc.dart';
import 'package:tunda/presentation/screens/home_page_screen.dart';

void main() {
  Bloc.observer = AppGlobalBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => FruitTesterBloc(),
        child: const HomePage(),
      ),
    );
  }
}

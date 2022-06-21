import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/layout/home_bottom_bar.dart';
import 'package:todo_app/shared/cubit/bloc_observer.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

main() {
  BlocOverrides.runZoned(
    () {
      // Use cubits...
      AppCubit();
    },
    blocObserver: MyBlocObserver(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeBottomBar(),
    );
  }
}

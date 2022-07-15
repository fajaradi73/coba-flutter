import 'package:flutter/material.dart';
import 'util/PermissionHandlerScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.purpleAccent.shade400,
            secondary: Colors.purpleAccent.shade700,
          )),
      home: const PermissionHandlerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

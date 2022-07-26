import 'package:flutter/material.dart';

import 'screen/widget/PermissionHandlerScreen.dart';

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
          primaryColor: Colors.purpleAccent.shade400,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.purpleAccent.shade400,
            secondary: Colors.purpleAccent.shade700,
          )),
      home: const PermissionHandlerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

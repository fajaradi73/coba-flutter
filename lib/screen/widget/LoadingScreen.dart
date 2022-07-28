
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget{
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          SizedBox(
            height: 40.0,
            width: 40.0,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

}
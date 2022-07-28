import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../preview/PreviewPage.dart';

class OpenFileScreen extends StatefulWidget{
  const OpenFileScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => OpenFileState();
}

class OpenFileState extends State<OpenFileScreen>{

  void _pickFile() async {

    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result = await FilePicker.platform.pickFiles();

    // if no file is picked
    if (result == null) return;

    // we get the file from result object
    final pathFile = result.files.single;
    print(pathFile);
    var file = File(pathFile.path!);
    _openFile(file);
  }

  void _openFile(File file) {
    // OpenFile.open(file.path);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PreviewPage(
              file: file,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Open File')),
        body: Center(
          child: MaterialButton(
            onPressed: () {
              _pickFile();
            },
            color: Theme.of(context).colorScheme.primary,
            child: const Text(
              'Pick and open file',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
    );
  }

}

import 'package:flutter/material.dart';
import 'package:coba_flutter/model/character.dart';

class RecycleViewWidget extends StatelessWidget{
  List<Character> characterList = <Character>[];

  RecycleViewWidget({Key? key, required this.characterList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: characterList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(characterList[index].name),
            subtitle: Text(characterList[index].nickname),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(characterList[index].img),
            ),
          );
        });
  }

}
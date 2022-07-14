// ignore_for_file: file_names

import 'dart:convert';

import 'package:coba_flutter/data/characterApi.dart';
import 'package:coba_flutter/model/character.dart';
import 'package:coba_flutter/util/LoadingScreen.dart';
import 'package:flutter/material.dart';

import 'RecycleViewWidget.dart';

class RecycleView extends StatefulWidget {
  const RecycleView({Key? key}) : super(key: key);

  @override
  _RecyleViewState createState() => _RecyleViewState();
}

class _RecyleViewState extends State<RecycleView> {
  List<Character> characterList = <Character>[];
  Widget appBarTitle = const Text(
    "Recycle View",
    style: TextStyle(color: Colors.white),
  );
  Icon actionIcon = const Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  bool _isSearching = false;
  String _searchText = "";

  _RecyleViewState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCharactersFromApi();
  }

  void getCharactersFromApi() async {
    CharacterApi.getCharacters().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        characterList = list.map((model) => Character.fromJson(model)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: appBarTitle,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (actionIcon.icon == Icons.search) {
                    actionIcon = const Icon(
                      Icons.close,
                      color: Colors.white,
                    );
                    appBarTitle = TextField(
                      controller: _searchQuery,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          hintText: "Search...",
                          hintStyle: TextStyle(color: Colors.white)),
                    );
                    _handleSearchStart();
                  } else {
                    _handleSearchEnd();
                  }
                });
              },
            ),
          ]),
      body: (characterList.isEmpty)
          ? const LoadingScreen()
          : _isSearching
              ? _buildSearchList()
              : _buildList(),
    );
  }

  RecycleViewWidget _buildList() {
    return RecycleViewWidget(characterList: characterList);
  }

  RecycleViewWidget _buildSearchList() {
    if (_searchText.isEmpty) {
      return RecycleViewWidget(characterList: characterList);
    } else {
      List<Character> _searchList = [];
      for (int i = 0; i < characterList.length; i++) {
        Character character = characterList.elementAt(i);
        String name = character.name;
        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(character);
        }
      }
      return RecycleViewWidget(characterList: _searchList);
    }
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      actionIcon = const Icon(
        Icons.search,
        color: Colors.white,
      );
      appBarTitle = const Text(
        "Search Sample",
        style: TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _searchQuery.clear();
    });
  }
}

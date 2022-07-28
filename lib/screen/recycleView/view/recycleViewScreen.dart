// ignore_for_file: file_names

import 'dart:convert';

import 'package:coba_flutter/data/api.dart';
import 'package:coba_flutter/screen/recycleView/model/character.dart';
import 'package:coba_flutter/screen/widget/LoadingScreen.dart';
import 'package:flutter/material.dart';

class RecycleView extends StatefulWidget {
  const RecycleView({Key? key}) : super(key: key);

  @override
  State<RecycleView> createState() => _RecyleViewState();
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

  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _numberOfPostsPerRequest = 10;
  final int _nextPageTrigger = 3;
  bool showBackToTopButton = false;

  // scroll controller
  ScrollController scrollController = ScrollController();

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
    _pageNumber = 0;
    _isLastPage = false;
    _loading = true;
    _error = false;
    scrollController = scrollController
      ..addListener(() {
        setState(() {
          if (scrollController.offset >= 10) {
            showBackToTopButton = true; // show the back-to-top button
          } else {
            showBackToTopButton = false; // hide the back-to-top button
          }
        });
      });

    getCharactersFromApi();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(seconds: 3), curve: Curves.linear);
  }

  void getCharactersFromApi() async {
    var offset = characterList.length;
    if (_pageNumber == 0) {
      offset = 0;
    }
    CharacterApi.getCharacters(_numberOfPostsPerRequest, offset, _searchText)
        .then((response) {
      Iterable list = json.decode(response.body);
      List<Character> listResponse =
          list.map((model) => Character.fromJson(model)).toList();

      setState(() {
        _isLastPage = listResponse.length < _numberOfPostsPerRequest;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        characterList.addAll(listResponse);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildCharacterList(),
      floatingActionButton: !showBackToTopButton
          ? null
          : FloatingActionButton(
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            ),
    );
  }

  _appBar() {
    return AppBar(
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
                    onSubmitted: (value) {
                      _handleSearch(value);
                    },
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
        ]);
  }

  void _handleSearch(value) {
    _searchText = value;
    _loading = true;
    _pageNumber = 0;
    characterList = [];
    getCharactersFromApi();
  }

  _buildCharacterList() {
    if (characterList.isEmpty) {
      if (_loading) {
        return const LoadingScreen();
      } else if (_error) {
        return Center(
          child: errorDialog(size: 20),
        );
      }
    }
    return recycleView(characterList);
  }

  errorDialog({required double size}) {
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An error occurred when fetching the posts.',
            style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _error = false;
                  getCharactersFromApi();
                });
              },
              child: const Text(
                "Retry",
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )),
        ],
      ),
    );
  }

  recycleView(List<Character> characterList) {
    return Stack(
      children: [
        ListView.builder(
            controller: scrollController,
            itemCount: characterList.length + (_isLastPage ? 0 : 1),
            itemBuilder: (context, index) {
              if (index == characterList.length - _nextPageTrigger) {
                getCharactersFromApi();
              }
              if (index == characterList.length) {
                if (_error) {
                  return Center(child: errorDialog(size: 15));
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(10),
                    child: LoadingScreen(),
                  );
                }
              }
              final character = characterList[index];
              return ListTile(
                title: Text(character.name),
                subtitle: Text(character.nickname),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(character.img),
                ),
              );
            }),
      ],
    );
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
        "Recycle View",
        style: TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _searchQuery.clear();
    });
  }
}

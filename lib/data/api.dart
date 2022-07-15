
import 'dart:async';
import 'package:http/http.dart' as http;

class CharacterApi {
  static Future getCharacters() {
    return http
        .get(Uri.parse("https://breakingbadapi.com/api/characters"), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '<Your token>'
    });
  }
}

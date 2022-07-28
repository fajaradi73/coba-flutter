
import 'dart:async';
import 'package:http/http.dart' as http;

class CharacterApi {
  static Future getCharacters(int limit, int offset, String name) {
    return http
        .get(Uri.parse("https://breakingbadapi.com/api/characters?limit=$limit&offset=$offset&name=$name"), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '<Your token>'
    });
  }
}

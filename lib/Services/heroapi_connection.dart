import 'dart:convert';
import 'package:learn_flutter_3/Models/hero.dart';
import 'package:http/http.dart' as http;

class HeroApiConnection {
  String heroName;
  HeroData heroData;

  HeroApiConnection({this.heroName});

  Future<HeroData> getData() async{
    http.Response response = await http.get(
        'https://www.superheroapi.com/api.php/3644182378939564/search/$heroName');
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      HeroData heroData = HeroData.fromJson(json);
      return heroData;
    } else {
      throw Exception('Failed to load HeroData');
    }
  }
}
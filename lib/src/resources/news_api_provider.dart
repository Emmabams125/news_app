import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item_model.dart';
import 'dart:async';
import 'repository.dart';

final root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source {
  http.Client client = http.Client();

  Future<List<int>> fetchTopIds() async {
    final response = await client.get(Uri.parse('$root/topstories.json'));
    final ids = json.decode(response.body).cast<int>();
    return ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get(Uri.parse('$root/item/$id.json'));
    final parsedJson = json.decode(response.body);
    return ItemModel.fromJson(parsedJson);
  }
}

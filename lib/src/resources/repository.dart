import 'dart:async';
import 'news_api_provider.dart';
import 'new_db_provider.dart';
import '../models/item_model.dart';

class Repository {
  List<Source> sources = <Source> [
    NewsDbProvider(),
    NewsApiProvider(),
  ];
  List<Cache> caches = <Cache>[
    NewsDbProvider(),
  ];

  Future<List<int>> fetchTopIds() async {
    // Assuming you want to fetch top ids from the API provider (sources[1])
    return await sources[1].fetchTopIds();
  }

  Future<ItemModel?> fetchItem(int id) async {
    ItemModel? item;
    for (var source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    if (item != null) {
      for (var cache in caches) {
        cache.addItem(item);
      }
    }

    return item;
  }

  clearCache() async{
    for(var cache in caches){
      await cache.clear();
    }
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel?> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}

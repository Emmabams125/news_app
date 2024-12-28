import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class CommentsBloc {
  final _repository = Repository();

  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel?>>>(); // Future<ItemModel?> here

  Stream<Map<int, Future<ItemModel?>>> get itemWithComments => _commentsOutput.stream;

  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel?>>>(
          (Map<int, Future<ItemModel?>> cache, int id, int index) {
        cache[id] = _repository.fetchItem(id);

        cache[id]?.then((ItemModel? item) {
          if (item != null) {
            for (int kidId in item.kids) {
              fetchItemWithComments(kidId);
            }
          }
        }).catchError((error) {
          print('Error fetching item with id $id: $error');
        });

        return cache;
      },
      <int, Future<ItemModel?>>{}, // Initial map with nullable Future
    );
  }

  void dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}


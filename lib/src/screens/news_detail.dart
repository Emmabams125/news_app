import 'package:flutter/material.dart';
import '../blocs/comments_provider.dart';
import '../models/item_model.dart';
import '../widgets/comment.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;

  NewsDetail({required this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder<Map<int, Future<ItemModel?>>?>(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel?>>?> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text('Loading'));
        }

        final itemFuture = snapshot.data?[itemId];

        return FutureBuilder<ItemModel?>(
          future: itemFuture,
          builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Center(child: Text('Loading'));
            }

            final item = itemSnapshot.data;
            if (item == null) {
              return Center(child: Text('Item not found'));
            }

            return buildList(item, snapshot.data ?? {});
          },
        );
      },
    );
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel?>> itemMap) {
    final commentsList = item.kids.map((kidId) {
      return Comment(
        itemId: kidId,
        itemMap: itemMap,
        depth: 0,
      );
    }).toList(); // Ensure it's a List

    return ListView(
      children: <Widget>[
        buildTitle(item),
        ...commentsList, // Spread operator to include all comments
      ],
    );
  }

  Widget buildTitle(ItemModel item) {
    return Container(
      margin: EdgeInsets.all(10.0),
      alignment: Alignment.topCenter,
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}



Widget buildTitle(ItemModel item) {
    return Container(
      margin: EdgeInsets.all(10.0),
      alignment: Alignment.topCenter,
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }



